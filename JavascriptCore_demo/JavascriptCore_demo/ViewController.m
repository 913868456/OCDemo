//
//  ViewController.m
//  JavascriptCore_demo
//
//  Created by ECHINACOOP1 on 2016/10/28.
//  Copyright © 2016年 蔺国防. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, weak)JSContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
    
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    
    
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, 200, 50);
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 setTitle:@"OC调用无参JS" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(function1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2 + 100, 200, 50);
    btn2.backgroundColor = [UIColor blackColor];
    [btn2 setTitle:@"OC调用JS(传参)" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(function2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)function1{
    
    [_webView stringByEvaluatingJavaScriptFromString:@"aaa()"];

}

- (void)function2{
    
    NSString *name = @"hello";
    int i = 520;
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"bbb('%@','%d')",name,i]];

}

#pragma mark - webViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    //获取JS运行环境
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //注册函数(无参数)
    _context[@"test1"] = ^(){
        [self method1];
    };
    
    //注册函数(有参数)
    _context[@"test2"] = ^(){
        
        NSArray *args = [JSContext currentArguments];//传过来的参数
        NSString *name = args[0];
        NSString *str = args[1];
        [self method2:name and:str];
    };

}

- (void)method1{

    NSLog(@"JS调用了无参数的OC方法");

}

- (void)method2:(NSString*)name and:(NSString*)str{
    
    NSLog(@"JS调用了有参数的OC方法 \n %@\n %@",name,str);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
