//
//  FKFormViewFieldCell.h
//  FDKK
//
//  Created by lei.FY on 2019/8/12.
//  Copyright © 2019 4dage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FKFormView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 FKFormViewFieldCell的类型
 
 - FKFormViewFieldCellTypeInputOnly:只有输入框
 - FKFormViewFieldCellTypeInputAndButton:输入框和按钮
 - FKFormViewFieldCellTypeInputAndTimingLabel:输入框和记时lable
 **/

typedef NS_ENUM(NSInteger, FKFormViewFieldCellType){
    FKFormViewFieldCellTypeInputOnly,              ///< 只有输入框
    FKFormViewFieldCellTypeInputAndActionButton,   ///< 输入框和按钮
    FKFormViewFieldCellTypeInputAndTimingLabel,    ///< 计时Label
    FKFormViewFieldCellTypeInputAndPassword,       ///< 如果密码输入项，需要secrity标志
    FKformViewFieldCellTypeInputWithLeftButton,
};

//点击左边按钮的通知，对应的field
extern NSNotificationName const FKFormViewFieldCellDidTapLeftButtonNotification;

//点击右边按钮的通知，对应的field
extern NSNotificationName const FKFormViewFieldCellDidTapRightButtonNotification;

//如果需要改变cell的类型为FKFormViewCellTypeInputAndTimingLabel,发送这个通知，并且附带对应的field对象
extern NSNotificationName const FKFormViewFieldCellChangeTypeToTimingLabelNotification;

extern NSNotificationName const FKFormViewFieldCellChangeTypeChangeRightTitleNotification;


/**
 表单字段cell
 **/

@interface FKFormViewFieldCell : UITableViewCell

@property (nonatomic,weak) UITextField  *textField;             /// < 输入框

@property (nonatomic,weak) UIButton     *actionButton;          /// < 动作按钮 比如获取验证码

@property (nonatomic,weak) UILabel      *timingLabel;           /// < 计时Label

@property (nonatomic,weak) UIButton     *securityButton;        /// < 是否密码显示的按钮

@property (nonatomic,weak) UIButton     *actionLeftButton;

@property (nonatomic,assign) FKFormViewFieldCellType type;      /// < Cell的类型

//字段类型
@property (nonatomic, weak) FKFormViewField *field;             ///< 对应的字段

@end

NS_ASSUME_NONNULL_END
