//
//  UserDelegateViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/5/19.
//  Copyright © 2017年 my. All rights reserved.
//

#import "UserDelegateViewController.h"

@interface UserDelegateViewController ()<UIWebViewDelegate>

@property(weak,nonatomic)IBOutlet  UIWebView    *userDelegateVC;
@property(nonatomic,assign)BOOL     isAuth;
@property(nonatomic,strong)NSURL    *url;

@end

@implementation UserDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.urlStr != nil && self.urlStr.length > 0) {
        self.title = @"银联在线支付用户服务协议";
        NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [self.userDelegateVC loadRequest:requst];
        self.userDelegateVC.delegate = self;
    }
    else
    {
        self.title = @"用户协议";
        self.url = [NSURL URLWithString:PATH(@"public/comm/agreement.html")];
        NSURLRequest *requst = [NSURLRequest requestWithURL:self.url];
        [self.userDelegateVC loadRequest:requst];
        self.userDelegateVC.delegate = self;
        [self showHUDWithMessage:nil];
    }
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
        if (self.isAuth) {
            return YES;
        }
        NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.url] delegate:self];
        [connect start];
        [webView stopLoading];
        return NO;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount]== 0) {
        self.isAuth = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.isAuth = YES;
    [self.userDelegateVC loadRequest:[NSURLRequest requestWithURL:self.url]];
    [connection cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
