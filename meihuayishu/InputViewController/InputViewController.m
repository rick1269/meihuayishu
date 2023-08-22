//
//  InputViewController.m
//  meihuayishu
//
//  Created by rick qiu on 2023/8/22.
//

#import "InputViewController.h"
#import "ResultViewController.h"

// InputViewController.m

@interface InputViewController ()

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *questionTextField;
@property (strong, nonatomic) UIButton *timeButton;
@property (strong, nonatomic) UIButton *customButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIButton *shareButton;

@end


@implementation InputViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"梅花易数排盘软件";
	// 设置背景颜色为白色
	self.view.backgroundColor = [UIColor whiteColor];
	
	// 姓名输入框
	self.nameTextField = [[UITextField alloc] init];
	self.nameTextField.placeholder = @"不输入默认佚名";
	[self.view addSubview:self.nameTextField];
	
	// 问卜事情输入框
	self.questionTextField = [[UITextField alloc] init];
	self.questionTextField.placeholder = @"一事一问";
	[self.view addSubview:self.questionTextField];
	
	// 时间起卦按钮
	self.timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.timeButton setTitle:@"时间起卦" forState:UIControlStateNormal];
	[self.view addSubview:self.timeButton];
	
	// 自定义起卦按钮
	self.customButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.customButton setTitle:@"自定义起卦" forState:UIControlStateNormal];
	[self.view addSubview:self.customButton];
	
	// 返回按钮
	self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.backButton setTitle:@"返回" forState:UIControlStateNormal];
	[self.view addSubview:self.backButton];
	
	// 保存结果按钮
	self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.saveButton setTitle:@"保存结果" forState:UIControlStateNormal];
	[self.view addSubview:self.saveButton];
	
	// 分享按钮
	self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
	[self.view addSubview:self.shareButton];
	
	// 设置控件的位置和大小
	// 注意：这里只是一个简单的布局，您可能需要根据实际需求进行调整
	CGFloat width = self.view.bounds.size.width;
	self.nameTextField.frame = CGRectMake(20, 100, width - 40, 40);
	self.questionTextField.frame = CGRectMake(20, 150, width - 40, 40);
	self.timeButton.frame = CGRectMake(20, 200, (width - 60) / 2, 40);
	self.customButton.frame = CGRectMake(width / 2 + 10, 200, (width - 60) / 2, 40);
	self.backButton.frame = CGRectMake(20, self.view.bounds.size.height - 60, (width - 60) / 3, 40);
	self.saveButton.frame = CGRectMake(width / 3 + 10, self.view.bounds.size.height - 60, (width - 60) / 3, 40);
	self.shareButton.frame = CGRectMake(2 * width / 3, self.view.bounds.size.height - 60, (width - 60) / 3, 40);
	
	// 设置文本框的边框和样式
	self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
	self.questionTextField.borderStyle = UITextBorderStyleRoundedRect;
	
	// 添加手势识别器以隐藏键盘
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:tapGesture];
	
	// 添加按钮的点击事件
	[self.timeButton addTarget:self action:@selector(timeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.customButton addTarget:self action:@selector(customButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.shareButton addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark - Button Actions

- (void)timeButtonTapped {
	// 时间起卦的逻辑
}

- (void)customButtonTapped {
	// 自定义起卦的逻辑
}

- (void)backButtonTapped {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonTapped {
	NSString *name = self.nameTextField.text.length > 0 ? self.nameTextField.text : @"佚名";
	NSString *question = self.questionTextField.text.length > 0 ? self.questionTextField.text : @"一事一问";
	NSString *date = [self getCurrentDate]; // 获取当前日期的方法

	if (self.didSaveRecord) {
		self.didSaveRecord(name, date, question);
	}

	[self.navigationController popViewControllerAnimated:YES];
}

// 获取当前日期的方法
- (NSString *)getCurrentDate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy年MM月dd日"];
	return [formatter stringFromDate:[NSDate date]];
}

- (void)shareButtonTapped {
	// 分享结果的逻辑
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}

@end

