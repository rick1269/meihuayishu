//
//  ViewController.m
//  meihuayishu
//
//  Created by rick qiu on 2023/8/22.
//
#import "ViewController.h"
#import "InputViewController.h"
#import "ResultViewController.h"
 
@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *records; // 存储卦信息的数组
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"梅花易数排盘软件";
	self.records = @[@"李华", @"王明", @"张强"];

	// 创建uitableview
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];

	// 创建uisearchbar
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
	searchBar.delegate = self; // 设置代理
	self.tableView.tableHeaderView = searchBar;
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:tapGesture]; // 点击空白处隐藏输入法

	
	// 注册UITableViewCell
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RecordCell"];

	// 添加UIButton
	UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[addButton setTitle:@"+ 新增卦信息" forState:UIControlStateNormal];
	[addButton addTarget:self action:@selector(addNewRecord) forControlEvents:UIControlEventTouchUpInside];
	addButton.translatesAutoresizingMaskIntoConstraints = NO; // 使用Auto Layout
	[self.view addSubview:addButton];

	// 设置UIButton的Auto Layout约束
	[NSLayoutConstraint activateConstraints:@[
		[addButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
		[addButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
		[addButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
		[addButton.heightAnchor constraintEqualToConstant:44]
	]];

	// 添加导航栏按钮
	UIBarButtonItem *cloudButton = [[UIBarButtonItem alloc] initWithTitle:@"云☁️" style:UIBarButtonItemStylePlain target:self action:nil];
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"⚙️" style:UIBarButtonItemStylePlain target:self action:nil];
	self.navigationItem.rightBarButtonItems = @[settingsButton, cloudButton];

}

- (void)addNewRecord {
	InputViewController *inputVC = [[InputViewController alloc] init];
	[self.navigationController pushViewController:inputVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RecordCell"];
	}
	cell.textLabel.text = self.records[indexPath.row];
	cell.detailTextLabel.text = @"2023年7月15日"; // 示例日期
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	ResultViewController *resultVC = [[ResultViewController alloc] init];
	[self.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}


@end
