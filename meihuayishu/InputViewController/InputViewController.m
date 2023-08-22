//
//  InputViewController.m
//  meihuayishu
//
//  Created by rick qiu on 2023/8/22.
//
#import "InputViewController.h"

@interface InputViewController ()

@property (nonatomic, strong) UILabel *gregorianLabel;
@property (nonatomic, strong) UILabel *lunarLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *questionTextField;
@property (nonatomic, strong) UIButton *computeButton;

@end

@implementation InputViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"梅花易数排盘软件";

	// 返回按钮
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
	self.navigationItem.leftBarButtonItem = backButton;

	// 设置日期
	[self setupDateLabels];

	// 设置姓名和问题输入
	[self setupTextFields];

	// 设置易经图案
	[self setupYaoImages];

	// 设置按钮
	[self setupComputeButton];

	// 点击空白处隐藏键盘
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:tapGesture];
}

- (void)setupDateLabels {
	self.gregorianLabel = [[UILabel alloc] init];
	self.gregorianLabel.text = @"公历 2023/08/23 10:30 AM";
	self.gregorianLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.gregorianLabel];

	self.lunarLabel = [[UILabel alloc] init];
	self.lunarLabel.text = @"农历 2023年七月初七 亥时";
	self.lunarLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.lunarLabel];

	// Constraints
	[NSLayoutConstraint activateConstraints:@[
		[self.gregorianLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
		[self.gregorianLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],

		[self.lunarLabel.topAnchor constraintEqualToAnchor:self.gregorianLabel.bottomAnchor constant:10],
		[self.lunarLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20]
	]];
}

- (void)setupTextFields {
	// Name
	UILabel *nameLabel = [[UILabel alloc] init];
	nameLabel.text = @"姓名：";
	nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:nameLabel];

	self.nameTextField = [[UITextField alloc] init];
	self.nameTextField.placeholder = @"不输入默认佚名";
	self.nameTextField.layer.borderColor = [UIColor grayColor].CGColor;
	self.nameTextField.layer.borderWidth = 0.5f;
	self.nameTextField.layer.cornerRadius = 5.0f;
	self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.nameTextField];

	// Question
	UILabel *questionLabel = [[UILabel alloc] init];
	questionLabel.text = @"问卜事情：";
	questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:questionLabel];

	self.questionTextField = [[UITextField alloc] init];
	self.questionTextField.placeholder = @"一事一问";
	self.questionTextField.layer.borderColor = [UIColor grayColor].CGColor;
	self.questionTextField.layer.borderWidth = 0.5f;
	self.questionTextField.layer.cornerRadius = 5.0f;
	self.questionTextField.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.questionTextField];

	// Constraints
	[NSLayoutConstraint activateConstraints:@[
		[nameLabel.topAnchor constraintEqualToAnchor:self.lunarLabel.bottomAnchor constant:20],
		[nameLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],

		[self.nameTextField.leadingAnchor constraintEqualToAnchor:self.questionTextField.leadingAnchor],
		[self.nameTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-150],
		[self.nameTextField.centerYAnchor constraintEqualToAnchor:nameLabel.centerYAnchor],
		
		[questionLabel.topAnchor constraintEqualToAnchor:nameLabel.bottomAnchor constant:20],
		[questionLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
		
		[self.questionTextField.leadingAnchor constraintEqualToAnchor:nameLabel.trailingAnchor constant:10],
		[self.questionTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
		[self.questionTextField.centerYAnchor constraintEqualToAnchor:questionLabel.centerYAnchor]
	]];
}

- (void)setupYaoImages {
	UIView *previousView = self.questionTextField;

	NSArray *yaoLabels = @[@"上爻", @"五爻", @"四爻", @"三爻", @"二爻", @"初爻"];
	for (NSString *labelText in yaoLabels) {
		UILabel *label = [[UILabel alloc] init];
		label.text = labelText;
		label.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:label];

		UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"图案1"]];
		imageView1.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:imageView1];

		UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"图案4"]];
		imageView2.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:imageView2];

		// Constraints
		[NSLayoutConstraint activateConstraints:@[
			[label.topAnchor constraintEqualToAnchor:previousView.bottomAnchor constant:20],
			[label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
			
			[imageView1.topAnchor constraintEqualToAnchor:label.topAnchor],
			[imageView1.leadingAnchor constraintEqualToAnchor:label.trailingAnchor constant:10],

			[imageView2.topAnchor constraintEqualToAnchor:label.topAnchor],
			[imageView2.leadingAnchor constraintEqualToAnchor:imageView1.trailingAnchor constant:10]
		]];

		previousView = label;
	}
}

- (void)setupComputeButton {
	self.computeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.computeButton setTitle:@"立即排盘" forState:UIControlStateNormal];
	self.computeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.computeButton];

	// Constraints
	[NSLayoutConstraint activateConstraints:@[
		[self.computeButton.topAnchor constraintEqualToAnchor:self.questionTextField.bottomAnchor constant:50],
		[self.computeButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
	]];
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}

- (void)backPressed {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
