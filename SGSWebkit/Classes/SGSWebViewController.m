//
//  SGSWebViewController.m
//  SGSWebkit_Example
//
//  Created by 黄佑成 on 2019/3/26.
//  Copyright © 2019 961629701@qq.com. All rights reserved.
//

#import "SGSWebViewController.h"

#ifdef DEBUG
/**
 debug 状态打印

 @param format 打印的属性值
 @param ... 打印的属性值
 @return 打印值
 */
#define debugLog(format, ...) fprintf(stderr,"%s %s [LINE %d] %s\t%s\n",__TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__,__PRETTY_FUNCTION__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);

#else

#define debugLog(format, ...) nil;

#endif

/*!
 *  @brief 懒加载宏
 *
 *  @param object     懒加载的属性
 *  @param assignment 懒加载属性为空时，需要执行的代码块
 *
 *  @return 懒加载属性
 */
#define Lazy(object, assignment...) ((object) = (object) ?: (assignment))

static int kLoadingContext;
static int kEstimatedProgressContext;

@interface SGSWebViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation SGSWebViewController

@synthesize configuration = _configuration;
@synthesize webView = _webView;
@synthesize progressBar = _progressBar;

#pragma mark - Lifecycle

- (instancetype)initWithRequest:(NSURLRequest *)request {
    return [self initWithConfiguration:nil request:request];
}

- (instancetype)initWithConfiguration:(WKWebViewConfiguration *)configuration request:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        _configuration = configuration;
        _request = request;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressBar];
    [self setupViewConstraints];
    [self.webView loadRequest:self.request];
    [self addObserverForWebView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)dealloc {
    NSLog(@"%@ is dealloc", self);
}


#pragma mark - Private Methods

/// 添加KVO监听
- (void)addObserverForWebView {
    if (_webView == nil) return;
    
    [_webView addObserver:self forKeyPath:@"loading"
                  options:NSKeyValueObservingOptionNew context:&kLoadingContext];
    [_webView addObserver:self forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew
                  context:&kEstimatedProgressContext];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

/// 移除KVO监听
- (void)removeObserverForWebView {
    if (_webView == nil) return;
    
    [_webView removeObserver:self forKeyPath:@"loading"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &kLoadingContext) {
        if (_webView != nil) {
            BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isLoading];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    } else if (context == &kEstimatedProgressContext) {
        float progress = [change[NSKeyValueChangeNewKey] floatValue];
        [self updateProgressValue:progress];
    } else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView) {
            self.title = self.webView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

/// 更新进度条
- (void)updateProgressValue:(float)value {
    if (self.progressBar.isHidden) {
        [self.progressBar setHidden:NO];
    }
    if (value >= 1.0f) {
        [self hideProgress];
    } else {
        [self.progressBar setProgress:value animated:YES];
    }
}

/// 隐藏进度条
- (void)hideProgress {
    self.progressBar.progress = 0;
    [self.progressBar setHidden:YES];
}

/// 设置约束
- (void)setupViewConstraints {
    id topLayoutGuide = self.topLayoutGuide;
    NSDictionary *bindingViews = @{@"topLayoutGuide": topLayoutGuide, @"progressView": self.progressBar};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressView]-0-|" options:kNilOptions metrics:nil views:bindingViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-0-[progressView(3)]" options:kNilOptions metrics:nil views:bindingViews]];
}

#pragma mark - WKNavigationDelegate
// 开始加载网页
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (_progressBar) {
        _progressBar.progress = webView.estimatedProgress;
        _progressBar.hidden = NO;
    }
}

// 临时加载网页失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hideProgress];
}

// 网页加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hideProgress];
}

// 网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideProgress];
}

// 网页重定向
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    debugLog(@"t重定向...");
}

// 决定响应策略
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if ([webView.URL.host isEqualToString:@"itunes.apple.com"]) {
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

// 授权认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
}

#pragma mark - Accessors
- (WKWebViewConfiguration *)configuration {
    return Lazy(_configuration, {
        _configuration = [[WKWebViewConfiguration alloc] init];
        _configuration.preferences.minimumFontSize = 12.0;
        _configuration;
    });
}

- (WKWebView *)webView {
    return Lazy(_webView, {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        _webView;
    });
}

- (UIProgressView *)progressBar {
    return Lazy(_progressBar, {
        _progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressBar.translatesAutoresizingMaskIntoConstraints = NO;
        _progressBar.tintColor = [UIColor redColor];
        _progressBar.hidden = YES;
        _progressBar;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
