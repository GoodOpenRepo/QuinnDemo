//
//  ViewController.m
//  FeedbackDemo
//
//  Created by Quinn on 2018/10/18.
//  Copyright © 2018 Quinn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)action:(UIButton *)sender {
    
    //这个方法通过传入参数来确定触发什么样的用户触觉反馈
        switch (sender.tag) {
            case 1:
            {
                UIImpactFeedbackGenerator * imp = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleHeavy];
                [imp impactOccurred];
            }
                break;
            case 2:
            {
                UIImpactFeedbackGenerator * imp = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
                [imp impactOccurred];
            }
                break;
            case 3:
            {
                UIImpactFeedbackGenerator * imp = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
                [imp impactOccurred];
            }
                break;
            case 4:
            {
                UINotificationFeedbackGenerator * imp = [[UINotificationFeedbackGenerator alloc]init];
                [imp notificationOccurred:UINotificationFeedbackTypeError];
            }
                break;
            case 5:
            {
                UINotificationFeedbackGenerator * imp = [[UINotificationFeedbackGenerator alloc]init];
                [imp notificationOccurred:UINotificationFeedbackTypeSuccess];
            }
                break;
            case 6:
            {
                UINotificationFeedbackGenerator * imp = [[UINotificationFeedbackGenerator alloc]init];
                [imp notificationOccurred:UINotificationFeedbackTypeWarning];
            }
                break;
            case 7:
            {
                UISelectionFeedbackGenerator * imp = [[UISelectionFeedbackGenerator alloc]init];
                [imp selectionChanged];
            }
                break;
            default:
                break;
        }
}



@end
