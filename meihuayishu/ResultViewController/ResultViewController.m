//
//  ResultViewController.m
//  meihuayishu
//
//  Created by rick qiu on 2023/8/22.
//

#import "ResultViewController.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guaImageView;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"梅花易数排盘软件";
}

- (IBAction)saveButtonTapped:(id)sender {
	// 保存结果逻辑
}

- (IBAction)shareButtonTapped:(id)sender {
	// 分享结果逻辑
}

@end

