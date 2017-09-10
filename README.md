# WeWorkGifs
Project I did for WeWork that is basically a Giphy API client that makes use of a Pinterest type layout

Setup:

1. cd WeWorkGifs
2. pod install
3. open WeWorkGifs.xcworkspace

First off, I wanted to say thank you for giving me this fun project. I really enjoyed working on it and trying to come up with creative ways to get the task done.

I used MVVM with RxSwift in conjuction with an API that uses Alamofire to fetch the gif data. My API Router made it really easy to send requests with just an enum value and a search query. I thought this would be especially nice if the project were to scale with many different backend endpoints created with varying http methods and paths.

For the layout, I went with a pinterest-type collection view because I really like how it lets the items have varying heights but the overall look is still really clean.

I didn't want to use a regular spinning modal, so I beefed up the cells with a progress bar across the bottom side using one of the nice WeWork highlight colors. SDWebImage helped with this in addition to caching the gifs so that we don't have to redownload them every time.

I thought it would be nice to be able use the gifs that you're searching for, so I made a cell tap open an action sheet to share on either iMessage, Facebook, or Twitter.

For the tests, I focused on the API. In the future, it would definitely be nice to do some UI testing to improve the pinterest layout.

1. How much time did you spend?

I think 15-20 hours.

2. What was the most difficult thing for you?

The most difficult thing was definitely the pinterest layout. I was using a regular collection flow layout at first and using delegate methods to calculate the size of the images which was working but the positioning on some of the cells was off. Eventually, I found the Ray Wenderlich tutorial and thought their solution of going deeper by subclassing a collection view layout was pretty clean.

3. What technical debt would you pay if you had one more iteration?

I'd like to use the decodable & encodable protocols from Swift 4 to parse the JSON response and make the overall API a little more reactive.

The biggest technical debt I would like to pay is the use of coordinators with RxSwift. This project stays on one screen so it wasn't at the top of my list, but if the project were to continue, I'd definitely like to have an app coordinator manage more of what the view controller is doing. As Soroush Khanlou always says, "In real life, children should never boss their parents around. In programming, I would argue children shouldn’t even know who their parents are!"

Thanks again!
