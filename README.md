# LFYFormView
一个方便快捷的可配置的登录注册页面的封装，包含标题，输入列表，验证码，按钮的快捷配置
一.使用说明


1.选择单个输入框的类型

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

2.便捷方法创建单个item

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

3.集成view
   FKFormView *formView = [[FKFormView alloc]initWithFrame:CGRectZero
                                               submitTitle:@"确定"
                                                 formTitle:@"密码登录"
                                                  delegate:self];
   formView.formBottomType = FKFormBottomButtonTypeAll;
   formView.bottomTitles  = @[@"验证码登录",
                              @"忘记密码"];
   [self addSubview:formView];
   
   //需要设置表单项目section 默认是手机号码登录
   FKFormViewField *phoneField = [FKFormViewField fieldWithType:FKformViewFieldTypeInputWithLeftButton
                                                     identifier:@"userName"
                                                    placeholder:@"输入手机号"];
   phoneField.keyBoardType =UIKeyboardTypeNumberPad;
   FKFormViewField *passwordField = [FKFormViewField fieldWithType:FKFormViewFieldTypeInputAndPassword
                                                        identifier:@"password"
                                                       placeholder:@"输入密码"];
   passwordField.isSecurity = YES;
   
   FKFormViewSection *phoneSection = [FKFormViewSection sectionWithIdentifier:@"sectionsUserName" fields:@[phoneField]];
   phoneSection.title = @"手机号码";
   
   FKFormViewSection *passwordSection = [FKFormViewSection sectionWithIdentifier:@"sectionsPassword" fields:@[passwordField]];
   passwordSection.title = @"密码";
   
   formView.sections = @[phoneSection,passwordSection];

