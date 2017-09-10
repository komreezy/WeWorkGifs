//
//  GifSearchCollectionViewController.swift
//  WeWorkGifs
//
//  Created by Komran Ghahremani on 9/2/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Social
import MessageUI

class GifSearchCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tintView: UIView!
    var searchBar: UISearchBar?
    
    fileprivate let screenWidth = UIScreen.main.bounds.width
    let viewModel = GifSearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        configureCollectionView()
        bindToRx()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignSearchResponder()
    }
    
    func bindToRx() {
        // bind search bar text to text variable and query for gifs on new text
        if let searchBar = searchBar {
            searchBar.rx.text.orEmpty
                .debounce(0.3, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [unowned self] query in
                    let request: GiphyRequest = query.characters.count > 0 ? .search(query) : .trending
                    self.viewModel.searchGifs(for: request)
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    
            }).addDisposableTo(disposeBag)
        }
        
        // tint when searching + there are no items in the collection view
        viewModel.tinted
            .asObservable()
            .subscribe(onNext: { [unowned self] shouldTint in
                self.tintView.isHidden = !shouldTint
        }).addDisposableTo(disposeBag)
        
        // bind results to collection view as data source
        viewModel.results
            .asObservable()
            .bind(to: collectionView
                .rx.items(cellIdentifier: GifCollectionViewCell.Identifier, cellType: GifCollectionViewCell.self)) {
                    row, gif, cell in
                    cell.configure(with: gif)
            }.addDisposableTo(disposeBag)
        
        // listen for errors from api loading incorrectly to display error
        viewModel.error
            .asObservable()
            .filter({ $0 != "" })
            .subscribe(onNext: { [unowned self] message in
                let close = UIAlertAction(title: "Reload", style: .cancel, handler: { [unowned self] _ in
                    self.viewModel.error.value = ""
                    self.viewModel.searchGifs(for: .trending)
                })
                
                alert(message: message, style: .alert, and: close, target: self)
            }).addDisposableTo(disposeBag)
        
        // when the user taps a cell open a share sheet
        collectionView.rx
            .modelSelected(Gif.self)
            .subscribe(onNext: { [unowned self] gif in
                guard let image = URL(string: gif.url) else {
                    return
                }
                
                var data: Data
                do {
                    data = try Data(contentsOf: image)
                } catch {
                    return
                }
                
                self.showShareActionSheet(with: data, or: image)
        }).addDisposableTo(disposeBag)
    }
    
    func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? ColumnLayout {
            layout.delegate = self
        }
        
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: GifCollectionViewCell.Identifier, bundle: nil),
                                forCellWithReuseIdentifier: GifCollectionViewCell.Identifier)
    }
    
    func createSearchBar() {
        searchBar = UISearchBar()
        searchBar?.delegate = self
        searchBar?.showsCancelButton = false
        searchBar?.placeholder = "  Search Gifs"
        searchBar?.returnKeyType = .done
        searchBar?.tintColor = UIColor(colorLiteralRed: 255.0/255.0,
                                       green: 190.0/255.0,
                                       blue: 62.0/255.0,
                                       alpha: 1.0)
        
        navigationItem.titleView = searchBar
    }
    
    func resignSearchResponder() {
        guard let searchBar = searchBar else { return }
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

extension GifSearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resignSearchResponder()
    }
}

extension GifSearchCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.tinted.value = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.tinted.value = false
        searchBar.resignFirstResponder()
    }
}

extension GifSearchCollectionViewController: ColumnLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return CGFloat(viewModel.results.value[indexPath.row].height)
    }
}

extension GifSearchCollectionViewController: UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, SocialSharable {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showShareActionSheet(with data: Data, or image: URL) {
        let close = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let messageShare = UIAlertAction(title: "iMessage", style: .default) { [unowned self] _ in
            guard let vc = self.shareSheet(for: data, on: .imessage) as? MFMessageComposeViewController else {
                return
            }
            
            vc.delegate = self
            vc.messageComposeDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
        let facebookShare = UIAlertAction(title: "Facebook", style: .default) { [unowned self] _ in
            guard let vc = self.shareSheet(for: data, on: .facebook) as? SLComposeViewController else {
                return
            }
            
            vc.setInitialText("Share to Facebook")
            vc.add(image)
            self.present(vc, animated: true, completion: nil)
            
        }
        let twitterShare = UIAlertAction(title: "Twitter", style: .default) { [unowned self] _ in
            guard let vc = self.shareSheet(for: data, on: .twitter) as? SLComposeViewController else {
                return
            }
            
            vc.setInitialText("Share to Twitter")
            vc.add(image)
            self.present(vc, animated: true, completion: nil)
        }
        
        alert(message: "Share", style: .actionSheet, and: messageShare, facebookShare, twitterShare, close, target: self)
    }
}
