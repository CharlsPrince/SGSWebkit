//
//  SGSWebViewController.h
//  SGSWebkit_Example
//
//  Created by 黄佑成 on 2019/3/26.
//  Copyright © 2019 961629701@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SGSWebProtocol <NSObject, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;

@optional
@property (nonatomic, strong) UIProgressView *progressBar;
- (instancetype)initWithRequest:(NSURLRequest *)request;
- (instancetype)initWithConfiguration:(nullable WKWebViewConfiguration *)configuration request:(NSURLRequest *)request;

@end

@interface SGSWebViewController : UIViewController<SGSWebProtocol>

@end

NS_ASSUME_NONNULL_END
