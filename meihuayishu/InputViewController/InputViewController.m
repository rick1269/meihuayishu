//
//  InputViewController.m
//  meihuayishu
//
//  Created by rick qiu on 2023/8/22.
//

#import "InputViewController.h"
#import "ResultViewController.h"

@interface InputViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *questionTextField;
@end

@implementation InputViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"梅花易数排盘软件";
}

- (IBAction)timeButtonTapped:(id)sender {
	ResultViewController *resultVC = [[ResultViewController alloc] init];
	[self.navigationController pushViewController:resultVC animated:YES];
}

- (IBAction)customButtonTapped:(id)sender {
	// 自定义起卦逻辑
}

@end
