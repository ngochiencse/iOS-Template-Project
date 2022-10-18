# iOS Template Project
This is a template project for ios application development using MVVM and Coordinator.  

[TOC]

## Requirements
- Swift
- [Cocoapods](https://cocoapods.org/)

## To Install
Clone the repo and run the project

## Project structure
**Note**: This section only show and explain items which does not exist in default structure of xcode. The remainings will be decided by xcode's default mechanism or by the developer himself/herself.
```bash
[Project Name]
├── Podfile
├── [Project Name]
│   ├── Common
│   │   ├── Environment.swift
│   │   ├── AppSecretsManager.swift
│   │   ├── Constant.swift
│   │   ├── Enum.swift
│   │   ├── Prefs.swift
│   │   ├── UrlDef.swift
│   │   └── Utils
│   │       ├── ArrayUtils.swift
│   │       ├── DateUtils.swift
│   │       ├── DictionaryUtils.swift
│   │       └── ...
│   ├── Model
│   │   ├── Info
│   │   └── API
│   ├── Features
│   │   ├── Core
│   │   ├── Splash
│   │   ├── Login
│   │   ├── Tutorial
│   │   ├── Tabbar
│   │   ├── Post
│   │   └── ...
│   ├── AppDelegate.swift
│   ├── Supporting Files
│   │   ├── Configurations
│   │   ├── ObjectiveC-Brigde-Header.h
│   │   └── ...
│   └── Libraries
└── .xcodeproj
```
Each of the above directory (or file) contains code for screen, logic, configuration files, etc. Describing briefly the purpose of each directory and file, we are starting hierarchically.  

- `Podfile`: Config file for cocoapods.
- `[Project Name]`: Main directory of project's source codes.
- `Common`: Contains global used code such as constant, enum, config, ...
 - `Common/Environment.swift`: Manage non-private development environment config such as api host, api path, api version, ...
 - `Common/AppSecretsManager.swift`: Contains secret key which will not be exposed when unarchive ipa.
 - `Common/Enum.swift`: `Enum`s those are used globally in the project.
 - `Common/Prefs.swift`: Contain interface for manage data stored locally on device, mainly on `UserDefaults`, or global variables.
 - `Common/PrefsImpl.swift`: Implementation of `Prefs`.
 - `Common/UrlDef.swift`: Define urls used in webview and others.
 - `Common/Utils`: Contains convenient code reused from other projects.
- `Model`: Contains model definition, parser and service (mainly network api) involving those models.
  - `Info`: Model definitions.
  - `API`: Contain base code for networking layer.
- `Features`: Separate app's functionalties by features. Each feature contains View, ViewModel, ViewController, Coordinator, custom view and other things involving feature of the app.
  - `Core`: Features that is shared across others in the app.
  - `...` : Other features.
- `AppDelegate`: Code for starting and controlling application.
- `Supporting Files`: Contains files for supporting purposes and others.
  - `Configurations`: Contains `.xcconfig` files for build configurations.
  - `ObjectiveC-Brigde-Header.h`: Bridging header for objective-c.
- `Service`: Contains services that runs globally across the app, such as: handle push notification, handle firebase dynamic links, update push token, ...
- `Libraries`: Contains static libraries.
- `[Project Name].xcodeproj`: Project xcode file.  

## Rules and Conventions
In order to keep project quality and insure development speed, please apply these rules and conventions to your working:  

- Swift Style Guide: Not mandatory but it is recommend that you follow [this guide](https://github.com/raywenderlich/swift-style-guide).
- Architecture: It is recommended that each screen should be implemented follow architecture MVVM-Coordinator as described below for clean and testable code. In some case if it is hard or time limit you can implement some screen by MVC instead of MVVM. But Coordinator is required to be compatible.
- Layout: Do not use storyboard, instead use xib. Using xib separate screens and components, make it easy to corporate and maintainance.
- API: please use only the solution provided as describe in section **Networking**. If it is not satisfy your case, please contact author for support.
- UI: Check section **Common UI Component**. If there are any kinds of components are used in this section, then please use it before searching any other solutions.
- Local Data: Local Data is managed as described in section `NSUserDefaults`. Please make sure local data is managed correctly following this section.
- Dependency Injection: It is recommended that use should apply Dependency Injection if possible to keep your code independent and testable. But it is not required so if feeling so hard to apply, then you can just skip and have it your way.

## Architeture
This project uses architect MVVM-Coordinator, you can read its detail [here](https://medium.com/@giovannyorozco24/mvvm-and-coordinator-pattern-together-8920fc0f1f55). This architect is used for the following benefits:  

- Distribution — Now our viewController doesn’t take care about the models anymore, it just send events to the view model and it perform the task, when it’s finished sends the response back to the view controller, actually the view controller doesn’t know what really happens under the hood because now it isn’t its responsibility :).
- Testability — the View Model knows nothing about the View, this allows us to test it easily. The View might be also tested, but since it is UIKit dependent you might want to skip it.
- Reusability — As our viewControllers doesn’t perform an specific task it’s easy to reuse a lot of code and views in the project as well as the view models.
- Scalability — now the project is easy to change or update because the roles are well defined and the view controllers doesn’t perform a lot of task as before with MVC (Massive view controllers).  

**Note**: You can implement a screen using MVC instead of MVVM since they are compatible through Coordinator.

### Coordinator
#### Protocol `Coordinator`
Coordinator is the component that controls navigation between screens. Every Coordinator in this app implements protocol `Coordinator`, which defined simply as following:
```swift
protocol Coordinator: class {
    func start()
}
```
This protocol simply has a method `start()` that will start the first screen of the coordinator
#### `AppCoordinator`
When app start it will create and start `AppCoordinator`. `AppCoordinator` is the main coordinator of the application. It contains "flows", which are `UIViewController`s or Coordinators. In this project there 4 flow:  

- **Splash**: The splash screen which will auto login, check access token, ... This flow only has 1 screen which is splash so it is a `UIViewController`.
- **Tutorial**: The tutorial which guide user how to use the app. This flow only has 1 screen which is splash so it is a `UIViewController`.
- **Auth**: Authentication flow of the app. Including screens that is related to login feature such as:
 - Login screen.
 - Registration screen.
 - Forgot password screen.
 - ...
- **Main**: Contains main screens of the applications which usually could be accessed after login success.  

These are main coordinators of the app. You can define any coordinator cooresponding to the features as you see fits.

## Networking
This template use [Moya](https://github.com/Moya/Moya) to implement networking. Base code for networking layer is contained in folder API with the following components: Plugin, Provider and Target.
### Plugin
Plugins is a [Moya Plugins](https://github.com/Moya/Moya/blob/master/docs/Plugins.md), which are used to modify requests and responses or perform side-effects. In this project `APIErrorProcessPlugin` is defined to transform the error information in order to transform response body into corresponding object, which is `APIErrorDetail`. Normally you wouldn't need to care about. These plugins will be integrated automatically into `Provider` which we will view detail later.
### Target
Using Moya starts with defining a [target](https://github.com/Moya/Moya/blob/master/docs/Targets.md) – typically some enum that conforms to the TargetType protocol. Then, the rest of your app deals only with those targets. Targets are some action that you want to take on the API, like `favoriteTweet(tweetID: String)`.  
In this project api is defined in `APITarget`. But you can add more target to separate api into many group as you see fit.  

In Target folder there are 1 more file:  

- `MultiTarget.swift`: Define supporting functions for using `Target` with Moya.  Normally you do not need to care about this file.  

**Note**: Sometimes you may not be able to find some api in a Target. Just try to find it in other Targets because there are some cases in which an api is shared among different section in api doc.
### Provider
`Provider`s are main component which in charge of configuring and executing api, just like [MoyaProvider](https://github.com/Moya/Moya/blob/master/docs/Providers.md). But in order to implement custom behaviors when executing api such as logging, authorizaton, refresh token, ... `Provider` is defined as wrapper around `MoyaProvider` following guide on [Moya doc](https://github.com/Moya/Moya/blob/master/docs/Examples/WrappingInAdapter.md).  
There are 4 `Provider`s created to use in this project:  

- `ProviderPlain`: Simple network call which included a network logger already.
- `ProviderAPIBasic`: Provide network api with network logger and error proccessing plugin (`APIErrorProcessPlugin`).
- `ProviderAPIWithAccessToken`: Similiar to `ProviderAPIBasic` but including with auto insert access token plugin (`AccessTokenPlugin`).  

So which `Provider` should I choose to use? That depends on your situation. Here are some examples in which demonstrates how to choose correct `Provider`:  

- If you're in login screen: Since you are not login yet, you do not need to use access token, nor you need to refresh token. In this case `ProviderAPIWithAccessToken` should not be used. But you need to process error from response body to handle, `ProviderPlain` does not support this function. So in the end, `ProviderAPIBasic` is the best choice.
- If you're in top screen: In this case you are login already, you need to use access token and also refresh token. So `ProviderAPIWithAccessToken` is needed to handle api properly.
- If you implement force update function: You just simply get content from a url, read the content and display force update alert if needed. In this case you don't need access token, refresh token or error proccessing plugin. You only need network logger to debug. So `ProviderPlain` is suitable.


For more detail please read Moya [document](https://github.com/Moya/Moya/tree/master/docs/Examples) and code sample generated by this project template.

Note: When call api make sure the context where api is called must perform a reference to `Provider` by property such as:
```swift
class ViewController: UIViewController {
	var api: Provider<AuthTarget>
}
```
If you don't do that, when the api is called it will be dealloc and no longer perform the request.

### Usage
Just like Moya, you can execute an api like this:
```swift
provider = ProviderAPIWithAccessToken<AuthTarget.top>()
provider.request(.userProfile("ashfurrow")).subscribe { event in
    switch event {
    case let .success(response):
        image = UIImage(data: response.data)
    case let .error(error):
        print(error)
    }
}
```
If you need to stub api with mock data you can config like this:
```swift
provider = ProviderAPIWithAccessToken<AuthTarget.top>(stubClosure: MoyaProvider.delayedStub(0.5))
```
### Error
#### Definitions
Error while excuting api is based on [MoyaError](https://github.com/Moya/Moya/blob/master/Sources/Moya/MoyaError.swift) which is defined as following:
```swift
/// A type representing possible errors Moya can throw.
public enum MoyaError: Swift.Error {

    /// Indicates a response failed to map to an image.
    case imageMapping(Response)

    /// Indicates a response failed to map to a JSON structure.
    case jsonMapping(Response)

    /// Indicates a response failed to map to a String.
    case stringMapping(Response)

    /// Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, Response)

    /// Indicates that Encodable couldn't be encoded into Data
    case encodableMapping(Swift.Error)

    /// Indicates a response failed with an invalid HTTP status code.
    case statusCode(Response)

    /// Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error, Response?)

    /// Indicates that an `Endpoint` failed to map to a `URLRequest`.
    case requestMapping(String)

    /// Indicates that an `Endpoint` failed to encode the parameters for the `URLRequest`.
    case parameterEncoding(Swift.Error)
}
```
But as api doc error specify. A transformation is perform so that if receive error response body the error will become `MoyaError.underlying(let error, _)`. In which error will may be:
```swift
enum APIError: Error {
    case ignore(_ error: Error)
    case accessTokenExpired(_ error: Error)
    case serverError(_ detail: APIErrorDetail)
    case parseError
    case systemError
}
```
The values of `APIError` has the following meaning:  

- `ignore`: The error has already been handled automatically (like access token expired, simple error like no internet connection, ...) and you should not handle it.
- `accessTokenExpired`: The api has encounter access token expired.
- `serverError`: A normal error return from server, it contains `APIErrorDetail`.
- `parseError`: When could not parse to get object from data, for example: if could not parse APIErrorDetail from response body returned by server then parseError is thrown.
- `systemError`: Error when encountering programming exception.

And `APIErrorDetail` is defined corresponding to error response body:
```swift
struct APIErrorDetail: Error, Codable {
    let code: Int
    let message: String?
    
    var localizedDescription: String {
        return message ?? ""
    }
}
```
#### Error handling
To handle error returned from api. There are 2 steps need to be performed:  

- Extract and parse error information.
- Handle common error across the app such as: network connection, access token expired, ...  

##### Extract and parse error information.
To extract and parse error information, you need to create a plugin and insert it into `MoyaProvider`. In this template a plugin named `APIErrorProcessPlugin`:
```swift
import Foundation
import Moya
import CocoaLumberjack

struct APIErrorProcessPlugin: PluginType {
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case let .success(moyaResponse):
            return .success(moyaResponse)
        case let .failure(error):
            DDLogError("APIErrorProcess on error: \(String(describing: error))")
            return .failure(processError(error))
        }
    }

    func processError(_ error: MoyaError) -> MoyaError {
        do {
            if let detail = try error.response?.map(APIErrorDetail.self,
                                                    atKeyPath: "error",
                                                    using: JSONDecoder(),
                                                    failsOnEmptyData: true) {
                DDLogError("Error content: \(String(describing: detail))")
                return MoyaError.underlying(APIError.serverError(detail), error.response)
            } else {
                return error
            }
        } catch let parseError {
            DDLogError("Parse error json failed: \(String(describing: parseError))")
            if let string = try? error.response?.mapString() {
                DDLogError("Error content: \(string)")
            }
        }
        return error
    }
}
```
Notice this line:
```swift
let detail = try error.response?.map(APIErrorDetail.self,
                                     atKeyPath: "error",
                                     using: JSONDecoder(),
                                     failsOnEmptyData: true)
```
Because `MoyaError` has a property name `response` which is the http response the request. So you can extract information and parsed to struct or class. Remember depends on each project's api response design the struct of error may be different. It's your job to modify the plugin to match with the corresponding api.  

**Note**: If you encounter a project with many different api, you can define different plugins to match with different api providers.  

After set up error processing plugin, you'll need to input it into the param of `MoyaProvider` as followings:
```swift
// Set up plugins
var mutablePlugins: [PluginType] = plugins
let errorProcessPlugin: APIErrorProcessPlugin = APIErrorProcessPlugin()
mutablePlugins.append(errorProcessPlugin)
// ...
provider = MoyaProvider(endpointClosure: endpointClosure,
                        requestClosure: requestClosure,
                        stubClosure: stubClosure,
                        session: session,
                        plugins: mutablePlugins,
                        trackInflights: trackInflights)
```
You'll find these lines of code in `ProviderAPIWithRefreshToken`. It is recommended that for each provider with different data and error format, you should create a class which subclass `Provider` with interface as specify in `Provider.swift`:
```swift
/**
 Base class for api provider. Do not use this class directly but has to through subclass.
 */
class Provider<Target> where Target: Moya.TargetType {
    func request(_ token: Target) -> Single<Moya.Response> {
        fatalError("This class is used directly which is forbidden")
    }
}
```
##### Handle common error
When request api there cases happens across many api such as: network connection, show alert when encounter api error, access token expired, ... So the good thing to do is to organize into one place to make it easy to maintain and expand. In this template handle common error is separated into 2 steps:  

- Identify and fire notification.
- Observe and handle notification.  

First, identify if the error is a common error, if yes, fire a notification. We will impelement this in subclass of `Provider`. Such as in `ProviderAPIWithAccessToken.swift`:
```swift
extension Notification.Name {
    static let AutoHandleAPIError: Notification.Name = Notification.Name("AutoHandleAPIError")
    static let AutoHandleNoInternetConnectionError: Notification.Name =
        Notification.Name("AutoHandleNoInternetConnectionError")
    static let AutoHandleAccessTokenExpired: Notification.Name = Notification.Name("AutoHandleAccessTokenExpired")
    static let AccountSuspendedStop: Notification.Name = Notification.Name("AccountSuspendedStop")
}

class ProviderAPIWithAccessToken<Target>: Provider<Target> where Target: Moya.TargetType {
    let provider: MoyaProvider<Target>
    // ...

    override func request(_ token: Target) -> Single<Moya.Response> {
        let request = provider.rx.request(token)
        return request
            .catchError({ (error) in
                if case MoyaError.underlying(let underlyingError, let response) = error,
                   case APIError.serverError(let detail) = underlyingError {
                    let accessTokenExpired: Bool = (detail.code == "401003")
                    if accessTokenExpired == true {
                        return Single.error(MoyaError.underlying(APIError.accessTokenExpired(error), response))
                    } else {
                        return Single.error(error)
                    }
                } else {
                    return Single.error(error)
                }
            })
            .catchError({ (error) in
                // Handle access token expired
                if case MoyaError.underlying(APIError.accessTokenExpired(_), _) = error,
                   self.autoHandleAccessTokenExpired == true {
                    NotificationCenter.default.post(name: .AutoHandleAccessTokenExpired, object: nil)
                    return Single.error(APIError.ignore(error))
                } else {
                    return Single.error(error)
                }
            })
            .catchCommonError(autoHandleNoInternetConnection: autoHandleNoInternetConnection,
                              autoHandleAPIError: autoHandleAPIError)
    }
}
```  
The `catchCommonError` method handle common errors like internet connection and api error. The detail is written as an extension so it can be used across different api providers:
```swift
extension Single where Element: Moya.Response {
    func handleCommonError(_ error: Error,
                           autoHandleNoInternetConnection: Bool,
                           autoHandleAPIError: Bool) -> Single<Element> {
        guard case MoyaError.underlying(let underlyingError, _) = error else {
            return Single<Element>.error(error)
        }
        // Handle no internet connection automatically if needed
        if case AFError.sessionTaskFailed(error: let sessionError) = underlyingError,
           let urlError = sessionError as? URLError,
           urlError.code == URLError.Code.notConnectedToInternet ||
            urlError.code == URLError.Code.timedOut {
            if autoHandleNoInternetConnection == true {
                NotificationCenter.default.post(name: .AutoHandleNoInternetConnectionError, object: error)
                return Single<Element>.error(APIError.ignore(error))
            } else {
                return Single<Element>.error(error)
            }
        }
        // Handle api error automatically if needed
        else if autoHandleAPIError == true {
            NotificationCenter.default.post(name: .AutoHandleAPIError, object: error)
            return Single<Element>.error(APIError.ignore(error))
        } else {
            return Single<Element>.error(error)
        }
    }

    func catchCommonError(autoHandleNoInternetConnection: Bool,
                          autoHandleAPIError: Bool) -> PrimitiveSequence<Trait, Element> {
        return catchError {(error) in
            let catched: PrimitiveSequence<Trait, Element>! =
                self.handleCommonError(error,
                                       autoHandleNoInternetConnection: autoHandleNoInternetConnection,
                                       autoHandleAPIError: autoHandleAPIError)
                as? PrimitiveSequence<Trait, Element>
            return catched
        }
    }
}
```

Next, we will observe the notifications. In this template it is recommended these will be observed in `RootViewModelImpl.swift`:
```swift
import Foundation
import RxSwift
import RxCocoa

class RootViewModelImpl: RootViewModel {
    var alertModel: BehaviorRelay<AlertModel?> = BehaviorRelay(value: nil)
    let onAccessTokenExpiredDismiss: PublishSubject<Void> = PublishSubject()
    let prefs: PrefsUserInfo & PrefsAccessToken
    var isAccessTokenExpired: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    init(prefs: PrefsUserInfo & PrefsAccessToken) {
        self.prefs = prefs
        setUpObserver()
    }

    func clearLocalData() {
        prefs.saveUserInfo(nil)
        prefs.saveAccessToken(nil)
    }

    func setUpObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccessTokenExpired),
                                               name: .AutoHandleAccessTokenExpired, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAPIError(_:)),
                                               name: .AutoHandleAPIError, object: nil)
    }

    @objc func handleAccessTokenExpired() {
        isAccessTokenExpired.accept(true)
    }

    @objc func handleAPIError(_ notification: Notification) {
        if let error: Error = notification.object as? Error {
            alertModel.accept(AlertModel(message: error.localizedDescription))
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

```

### MVVM
MVVM is used in this project but with some customized components for rapid developments:
#### `AlertPresentableViewModel`
This is a protocol implemented for displaying `UIAlert` in MVVM architect. It is written according to [this tutorial](https://medium.com/@isaaliev12/a-little-tip-on-alerts-with-mvvm-in-ios-c5e363a9a330) with some adjustments. In order to use it, you can use `BasicViewModel` which has already integrated `AlertPresentableViewModel` and will be described in detail later. Or you can implement protocol `AlertPresentableViewModel` such as:
```swift
protocol LoginViewModel: class, AlertPresentableViewModel {

}
```
Then in implementation:
```swift
class LoginViewModelImpl: LoginViewModel {
	var alertModel: BehaviorRelay<AlertModel?> = BehaviorRelay(value: nil)
    
    // Handle event when tap login button
    func login() {
    
    }
}
```
Binding `AlertPresentableViewModel` in ViewController by calling method `bindToAlerts` from UIViewController:
```swift
class LoginViewController: BaseViewController {
    var viewModel: LoginViewModel
    
    var alertViewModel: AlertPresentableViewModel {
		return viewModel
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        // More init code here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Bind to AlertPresentableViewModel here
        bindToAlerts()
    }
            
    @IBAction func tapButtonLogin(_ sender: Any) {
        viewModel.login()
    }
}
```
Supposed that you want to display an alert when tap on login button, then in method `login` of `LoginViewModelImpl.swift`, add the following code like this:
```swift
class LoginViewModelImpl: LoginViewModel {
	var alertModel: BehaviorRelay<AlertModel?> = BehaviorRelay(value: nil)
    
    // Handle event when tap login button
    func login() {
    	alertModel.accept(
                AlertModel(actionModels: [AlertModel.ActionModel(title: "OK", style: .default, handler: nil)],
                           title: "Action",
                           message: "Login button clicked",
                           prefferedStyle: .alert))
    }
}
```
#### `LoadingIndicatorViewModel`
Show loading indicator is one the most common task when performing async task in ios app. This ViewModel is created to help show loading indicator more easily. To use it, similiar to `LoadingIndicatorViewModel`, you can use `BasicViewModel` which has already integrated `AlertPresentableViewModel` and will be described in detail later. Or you can implement protocol `LoadingIndicatorViewModel` by yourself like `AlertPresentableViewModel`.
In `LoadingIndicatorViewModel` there is 2 property corresponding to control displaying [MBProgressHUD](https://github.com/jdg/MBProgressHUD) and `UIActivityIndicatorView`:
- `showProgressHUD`: Control displaying [MBProgressHUD](https://github.com/jdg/MBProgressHUD).
- `showIndicator`: Control displaying `UIActivityIndicatorView`.  

#### `BasicViewModel`
`BasicViewModel` is a convenient ViewModel which contains frequently used logic modules including:
- `AlertPresentableViewModel`: Check section `AlertPresentableViewModel` above.
- `LoadingIndicatorViewModel`: Check section `LoadingIndicatorViewModel` above.

`BasicViewModel` has alread been integrated into `BaseViewController`. So whenever you declare a subclass of `BaseViewController` you can retrieve and use like this:
```swift
import Moya
import RxSwift
import NSObject_Rx

class FooViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Use AlertPresentableViewModel
        basicViewModel.alertModel.accept(
            AlertModel(actionModels: [AlertModel.ActionModel(title: "OK", style: .default, handler: nil)],
                       title: "Action",
                       message: "Login button clicked",
                       prefferedStyle: .alert))
        
       // Use LoadingIndicatorViewModel
        basicViewModel.showIndicator.accept(true)
        basicViewModel.showProgressHUD.accept(true)
}
```
The sample code above is just for demonstrating on how to use. In face, you should include `BasiceViewModel` in your ViewModel like the following:
```swift
// LoginViewModel.swift
import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModel: class {
    var basicViewModel: BasicViewModel { get }
    var email: BehaviorRelay<String?> { get set }
    var password: BehaviorRelay<String?> { get set }
    func login()
}
```
```swift
// LoginViewModelImpl.swift
import Foundation
import Alamofire
import Moya
import RxSwift
import RxCocoa
import NSObject_Rx

class LoginViewModelImpl: NSObject, LoginViewModel {
    private(set) var basicViewModel: BasicViewModel
    var email: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var password: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let prefs: PrefsAccessToken
    
    init(basicViewModel: BasicViewModel, prefs: PrefsAccessToken) {
        self.basicViewModel = basicViewModel
        self.prefs = prefs
    }
        
    func login() {
        let emailClean: String = email.value?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) ?? ""
        if emailClean.count <= 0 {
            basicViewModel.alertModel.accept(AlertModel(message: "ログインIDもしくはパスワードが異なっています。"))
            return
        }
        
        let passwordClean: String = password.value ?? ""
        if passwordClean.count <= 0 {
            basicViewModel.alertModel.accept(AlertModel(message: "ログインIDもしくはパスワードが異なっています。"))
            return
        }

        basicViewModel.showProgressHUD.accept(true)
        basicViewModel.api.request(MultiTarget(SampleTarget.login(email: emailClean, password: passwordClean))).subscribe { event in
            switch event {
            case .success(_):
            	// Handle success
                break
            case .error(let error):
            	// Handle error
                break
            }
            self.basicViewModel.showProgressHUD.accept(false)
        }.disposed(by: rx.disposeBag)
    }
}

```
```swift
// LoginViewController.swift
import UIKit
import MBProgressHUD
import Alamofire
import RxSwift
import NSObject_Rx
import RxBiBinding

class LoginViewController: BaseViewController {
    var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(basicViewModel: viewModel.basicViewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
                
    @IBAction func tapButtonLogin(_ sender: Any) {
        viewModel.login()
    }
}
```
## Using `UserDefaults`
When loading local data from `UserDefaults` you shouldn't use this class directly. Example:
```swift
UserDefaults.standard.object(forKey: "accessToken")
```
Using this way developer has to remember what the key is, what data type does it return. This causes bug, miss understanding and disimprove code readability, specially when working in team.
Instead add a method to class `Prefs` as following:
```swift
public func getAccessToken() -> String? {
   let defaults : UserDefaults = UserDefaults.standard
   let accessToken : String? = defaults.string(forKey: "accessToken")
   return accessToken
}
```
A little time consuming but this improve readibility significantly. Moreover every value in `UserDefaults` is usually shared by many developers, so this helps developers to work more easily, eliminate unnecessary time for question and answer.
In case saving local data to `UserDefaults`, do the same thing, instead of:
```swift
UserDefaults.standard.set(accessToken, forKey: "accessToken")
```
Add a method to `Prefs`
```swift
public func saveAccessToken(accessToken : String) {
   let defaults : UserDefaults = UserDefaults.standard
   defaults.set(accessToken, forKey: "accessToken")
   defaults.synchronize()
}
```
In order to help support [Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection), data can be group into separate protocols defined in an interface file `Prefs.swift` like the following:
```swift
protocol PrefsShowTutorial: class {
    func setShowTutorial(showTutorial : Bool)
    func isShowTutorial() -> Bool
}
```
In `PrefsImpl.swift` implementation is like:
```swift
extension PrefsImpl: PrefsShowTutorial {
    public func setShowTutorial(showTutorial : Bool) {
        let defaults : UserDefaults = UserDefaults.standard
        defaults.set(showTutorial, forKey: "showTutorial")
        defaults.synchronize()
    }
    
    public func isShowTutorial() -> Bool {
        let defaults : UserDefaults = UserDefaults.standard
        var showTutorial : Bool
        if let boolObject = defaults.object(forKey: "showTutorial") {
            showTutorial = boolObject as! Bool
        } else {
            showTutorial = false
        }
        return showTutorial
    }
}
```
With that, in modules that need to check `isShowTutorial`, we can define it as follow:
```swift
class Foo {
	let prefs: PrefsShowTutorial
    init(prefs: PrefsShowTutorial) {
    	self.prefs = prefs
    }
    func foo() {
    	if prefs.isShowTutorial() {
        	print("Show tutorial")
        } else {
        	print("Not show tutorial")
        }
    }
}
```
So when we want to mock local data for unit test, we can define mock prefs like this:
```swift
class PrefsMock: PrefsShowTutorial {
	public func setShowTutorial(showTutorial : Bool) {
        // Do nothing
    }

    public func isShowTutorial() -> Bool {
		return true
    }
}
```
Then we can apply Dependency Injection:
```swift
let mock: PrefsShowTutorial = PrefsMock()
let foo = Foo(prefs: mock)
foo.foo()
```

## Build configurations
This template has already integrate build configuration by using 2 different mechanism: `Environment` and `AppSecrets`.
### Environment
`Environment` is a build configurations mechanism build on using `.xcconfig` file. It was build based on the following [tutorial](https://www.freecodecamp.org/news/managing-different-environments-and-configurations-for-ios-projects-7970327dd9c9) (or if the link is down, you can see cached version [here](https://drive.google.com/file/d/1jDZeSj2ZVOgo3okXV_HjKihKZxj9Ahgo/view?usp=sharing) instead).  
The implementation is in `Common/Environment.swift`. This class manage non-private development environment config such as api host, api path, api version, ... Every config this class manage will be exposed through `info.plist` when unarchive the ipa file in order to make it easier for cheching and debugging.
### AppSecrets
`AppSecrets`, on contract with `Environment`, store its value in a swift file. Thus making it not possible for investigating its content by unarchiving the ipa file. The purpose of this mechanism, as its name, is to manage build configuration but keep secrets of the app from being leaked.
##### Configure AppSecrets
In order add a key `AppSecret`, open file `Common/AppSecretsManager` and perform these steps:  

- Define key in protocol `AppSecrets`. Example: 
 
```swift 
    protocol AppSecrets {  
        var secretKey: String { get }  
    }  
```  

- Create a class that implements protocol `AppSecrets` and add value for the corresponding key. Example: 
 
```swift  
    fileprivate class AppSecretsStaging: AppSecrets {  
        let secretKey: String = "9667048833"  
    }  
    
```  

**Note**: The class should be set `private` or `fileprivate` for better encapsulation.

#### Access AppSecrets
`AppSecrets` is managed by class `AppSecretsManager`. This class is iniated with `Environment` as its dependency. The purpose of this is to auto return `AppSecrets` corresponding to current Environment. So with an `AppSecrets` key as above example, the code to access the value should be:
```swift
AppSecretsManager.shared.content.secretKey
```

## Common UI Component
### Tabbar
This template use [BraveTabbarController](https://github.com/BraveSoft-Vietnam/BraveTabbarController.git) (this is a DIY repo) to implement tabbar UI. UITabbarController is good but not easy to customize. Such as: if you want to customize tab bar icons, you have to follow apple design guides, which is complicated. Moreover, UITabbarController is good to use in storyboard, but not as well in xib. BraveTabbarController is created to mimic UITabbarController but free developers from apple's complicated design guides.
### Rounded button and Rounded View
This template use [RoundedUI](https://github.com/BraveSoft-Vietnam/RoundedUI.git) (this is a DIY repo) to implement rounded button and rounded view. This framework helps user to config rounded attributes conveniently in code and even on interface builder.

# Dependencies
This template's depends mostly on [github](https://github.com/), the others are private DIY cocoapods or forks from github including:  

- [BraveTabbarController](https://github.com/BraveSoft-Vietnam/BraveTabbarController.git) (DIY repo)
- [RoundedUI](https://github.com/BraveSoft-Vietnam/RoundedUI.git) (DIY repo)

# Author

Hien, ngochiencse@gmail.com
