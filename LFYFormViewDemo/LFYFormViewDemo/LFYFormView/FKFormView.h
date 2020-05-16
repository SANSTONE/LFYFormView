//
//  FKFormView.h
//  FDKK
//
//  Created by lei.FY on 2019/8/12.
//  Copyright © 2019 4dage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

#ifndef UIColorMake
# define UIColorMake(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]
#endif

#define FK_SELECT_COLOR   UIColorMake(0, 200, 175, 1)
#define FK_NOSELECT_COLOR  UIColorMake(138, 138, 138, 1)
#define FK_BACKBROUND_COLOR  UIColorMake(23, 26, 26, 1)
#define FK_ITEMGROUP_COLOR UIColorMake(37, 40, 40, 1)
#define FK_TEXTNOTSELECT_COLOR UIColorMake(93, 93, 93, 1)

NS_ASSUME_NONNULL_BEGIN

@class FKFormViewSection, FKFormView;

#pragma mark - FKFormViewField

/**
 字段类型
 
 - VEXFormViewFieldTypeInput:                   输入框
 - VEXFormViewFieldTypeInputWithRightButton:    附带右边按钮的输入框
 */
typedef NS_ENUM(NSUInteger, FKFormViewFieldType) {
    FKFormViewFieldTypeInput,                  ///< 输入框
    FKFormViewFieldTypeInputWithRightButton,   ///< 附带右边按钮的输入框
    FKFormViewFieldTypeInputAndTimingLabel,    ///< 计时Label
    FKFormViewFieldTypeInputAndPassword,       ///< 如果密码输入项，需要secrity标志
    FKformViewFieldTypeInputWithLeftButton,    ///< 左边有选择按钮
};

/**
 数据字段
 */
@interface FKFormViewField : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;                 ///< 标识符
@property (nonatomic, copy, readonly) NSString *placeholder;                ///< 占位字符
@property (nonatomic, copy) id                 value;                       ///< 值
@property (nonatomic, copy, readonly) NSString *rightButtonTitle;           ///< 右边按钮标题
@property (nonatomic, copy, readonly) NSString *rightButtonDisableTitle;    ///< 右边按钮禁用标题
@property (nonatomic, assign, readonly) FKFormViewFieldType  type;          ///< 字段类型
@property (nonatomic, assign) BOOL                           isSecurity;    ///< 是否安全，和TextField中的Security属性对应
@property (nonatomic, assign) UIKeyboardType                 keyBoardType;  ///< 键盘类型

// 便捷方法
+ (instancetype)fieldWithType:(FKFormViewFieldType)type
                   identifier:(NSString *)identifier
                  placeholder:(NSString *)placeholder;

+ (instancetype)fieldWithType:(FKFormViewFieldType)type
                   identifier:(NSString *)identifier
                  placeholder:(NSString *)placeholder
             rightButtonTitle:(NSString *)rightButtonTitle
      rightButtonDisableTitle:(NSString *)rightButtonDisableTitle;

- (instancetype)initWithType:(FKFormViewFieldType)type
                  identifier:(NSString *)identifier
                 placeholder:(NSString *)placeholder;

- (instancetype)initWithType:(FKFormViewFieldType)type
                  identifier:(NSString *)identifier
                 placeholder:(NSString *)placeholder
            rightButtonTitle:(NSString *)rightButtonTitle
     rightButtonDisableTitle:(NSString *)rightButtonDisableTitle;

@end

#pragma mark - FKFormViewSection


/**
 分组
 */
@interface FKFormViewSection : NSObject

@property (nonatomic, readonly) NSArray<FKFormViewField *> *fields;     ///< 字段
@property (nonatomic, copy, readonly) NSString              *identifier; ///< 标识符
@property (nonatomic, copy) NSString                        *title;      ///< Section的标题

// 便捷方法
- (instancetype)initWithIdentifier:(NSString *)identifier
                            fields:(NSArray<FKFormViewField *> *)fields;

+ (instancetype)sectionWithIdentifier:(NSString *)identifier
                               fields:(NSArray<FKFormViewField *> *)fields;

/**
 添加字段
 
 @param field 字段
 */
- (void)addField:(FKFormViewField *)field;

/**
 批量添加字段
 
 @param fields 字段数组
 */
- (void)addFields:(NSArray<FKFormViewField *> *)fields;

/**
 清空字段
 */
- (void)clearFields;

@end


#pragma mark - FKFormViewDelegate

/**
 底部跳转按钮类型
 
 - FKFormBottomButtonTypeLeft:          有左边按钮
 - FKFormBottomButtonTypeRight:         有右边按钮
 - FKFormBottomButtonTypeAll:           左边和右边按钮
 - FKFormBottomButtonTypeNone:          没有
 
 */
typedef NS_ENUM(NSUInteger, FKFormBottomButtonType) {
    FKFormBottomButtonTypeLeft,                 ///< 有左边按钮
    FKFormBottomButtonTypeRight,                ///< 有右边按钮
    FKFormBottomButtonTypeAll,                  ///< 左边和右边按钮
    FKFormBottomButtonTypeNone,                 ///< 没有
};

/**
 VEXFormView的相关回调
 */
@protocol FKFormViewDelegate <NSObject>


/**
 提交表单
 
 @param formView 表单
 @param sections 对应的数据
 */
- (void)formView:(FKFormView *)formView didSubmitWithSections:(NSArray<FKFormViewSection *> *)sections;

/**
 底部按钮响应 左边
 
 @param formView 表单
 @param titles 底部按钮标题
 */
- (void)formView:(FKFormView *)formView tapBottomleft:(NSArray<NSString *> *)titles tapType:(FKFormBottomButtonType)tapType;

/**
 底部按钮响应 右边
 
 @param formView 表单
 @param titles 底部按钮标题
 */
- (void)formView:(FKFormView *)formView tapBottomRight:(NSArray<NSString *> *)titles tapType:(FKFormBottomButtonType)tapType;


@end



#pragma mark FKFromView


@interface FKFormView : UIView

@property (nonatomic, weak)   id<FKFormViewDelegate>            delegate;           ///< 代理
@property (nonatomic, strong) NSArray                           <FKFormViewSection *>*sections;  ///< 数据
@property (nonatomic, strong) NSArray                           <NSString *>*bottomTitles; ///< 底部按钮title
@property (nonatomic, assign) FKFormBottomButtonType            formBottomType;
@property (nonatomic, strong) NSString                          *formTitle;
@property (nonatomic, strong) NSMutableArray                    <FKFormViewSection *> *dataSource;   ///< 数据
/**
 初始化方法
 
 @param frame       布局未知
 @param submitTitle 提交按钮标题
 @param formTitle   表单标题
 @param delegate    代理
 @return 返回初始化号好的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                  submitTitle:(NSString *)submitTitle
                    formTitle:(NSString *)formTitle
                     delegate:(id<FKFormViewDelegate>)delegate;




@end



#pragma mark - NSArray (FKFormView)


/**
 VEXFormView数组的扩展
 
 方便根据id获取数组中对应的FKFormViewSection和FKFormViewField对象
 */
@interface NSArray (FKFormView)

/**
 根据id获取数组中的FKFormViewSection对象
 
 @param identifier FKFormViewSection的id
 @return 返回对应的FKFormViewSection对象，如果没有id一样的，则返回nil
 */
- (FKFormViewSection *)sectionForIdentifier:(NSString *)identifier;

/**
 根据id获取数组中的FKFormViewField对象
 
 @param identifier FKFormViewField的id
 @return 返回对应的FKFormViewField对象，如果没有id一样的，则返回nil
 */
- (FKFormViewField *)fieldForIdentifier:(NSString *)identifier;

@end



NS_ASSUME_NONNULL_END
