//
//  InputViewController.h
//  meihuayishu
//
//  Created by rick qiu on 2023/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputViewController : UIViewController

@property (nonatomic, copy) void (^didSaveRecord)(NSString *name, NSString *date, NSString *question); // 回调属性，以便在保存数据时通知ViewController。


@end

NS_ASSUME_NONNULL_END
