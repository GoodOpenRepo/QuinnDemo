//
//  ViewController.m
//  AFNDemo
//
//  Created by Quinn on 2019/1/31.
//  Copyright © 2019 Quinn. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 20;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ttttt_vvvvv_bbbb" ofType:@"zip"];
//    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSData *strData = [@"ttttt_vvvvv_bbbb.zip" dataUsingEncoding:NSUTF8StringEncoding];

    
    
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [session POST:@"http://39.105.26.255:9060/swaying/uploadfile" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        [formData appendPartWithFileData :data name:@"file_content" fileName:@"ttttt_vvvvv_bbbb.zip" mimeType:@"multipart/form-data"];
        [formData appendPartWithFormData:strData name:@"file_name"];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        
        
    }];
    
//
//    [manager POST:@"http://39.105.26.255:9060/swaying/uploadfile" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
////        [formData appendPartWithFormData:data name:@"file_content"];
//        [formData appendPartWithFileData:data name:@"file_content" fileName:@"ttttt_vvvvv_bbbb.zip" mimeType:@"application/octet-stream; charset=UTF-8"];
//
//        [formData appendPartWithFormData:strData name:@"file_name"];
//
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"发送成功");
//
//        NSLog(@"responseObject == %@", responseObject);
//
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        NSLog(@"发送失败");
//    }];


}

@end
