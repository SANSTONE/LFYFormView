//
//  FKFormView.m
//  FDKK
//
//  Created by lei.FY on 2019/8/12.
//  Copyright © 2019 4dage. All rights reserved.
//

#import "FKFormView.h"
#import "FKFormView.h"
#import "FKFormViewFieldCell.h"
#import "FKFormViewSectionHeaderView.h"


@class FKFormViewSection;


#pragma mark - FKFormViewSection


/**
 FKFormViewSection相关回调
 */
@protocol FKFormViewSectionDelegate <NSObject>


/**
 section中的fields有更新
 
 @param section 对应的Section
 @param fields 更新后的fields
 */
- (void)section:(FKFormViewSection *)section fieldsDidChange:(NSArray<FKFormViewField *> *)fields;

@end

@interface FKFormViewSection ()

@property (nonatomic, weak) id<FKFormViewSectionDelegate> delegate;        ///< 代理
@property (nonatomic, strong) NSMutableArray<FKFormViewField *> *pfields;   ///< 字段

@end




#pragma mark - FKFormView

// 复用ID
static NSString * const kFieldCellReuseID = @"FKFormViewFieldCell";
static NSString * const kSectionHeaderReuseID = @"FKFormViewSectionHeaderView";


@interface FKFormView() <UITableViewDelegate, UITableViewDataSource, FKFormViewSectionDelegate>

@property (nonatomic,weak) UITableView *tableView;              ///< 列表

@property (nonatomic,weak) UIButton    *submitButton;           ///< 提交按钮

@property (nonatomic,weak) UILabel     *formTitleLabel;         ///< 表单标题文本框

@property (nonatomic,weak) UIButton    *formBottomLeftButton;   ///< 表单左边按钮

@property (nonatomic,weak) UIButton    *formBottomRightButton;  ///< 表单底部右边按钮



@end


@implementation FKFormView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
                  submitTitle:(NSString *)submitTitle
                    formTitle:(NSString *)formTitle
                     delegate:(id<FKFormViewDelegate>)delegate{
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
        [self.submitButton setTitle:submitTitle forState:UIControlStateNormal];
        self.formTitleLabel.text = formTitle;
      
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubviews];
}

-(void)setupSubviews{
   
    [self addTableView];
    [self addSubmitButton];
    [self addFormTitleLabel];
    [self addBottomButton];
    
}

#pragma mark - Setter
-(void)setFormTitle:(NSString *)formTitle{
    if (_formTitle != formTitle) {
        _formTitle = formTitle;
        self.formTitleLabel.text = formTitle;
    }
}

- (void)setSections:(NSArray<FKFormViewSection *> *)sections {
    if (_sections != sections) {
        _sections = sections;
        
        [self.dataSource removeAllObjects];
        if (sections) {
            [self.dataSource addObjectsFromArray:sections];
        }
        [self.tableView reloadData];
    }
}

- (void)setFormBottomType:(FKFormBottomButtonType)formBottomType{
    if (_formBottomType != formBottomType) {
        _formBottomType = formBottomType;
        switch (formBottomType) {
            case FKFormBottomButtonTypeAll:
            {
                self.formBottomLeftButton.hidden = NO;
                self.formBottomRightButton.hidden = NO;
                break;
            }
            case FKFormBottomButtonTypeLeft:
            {
                self.formBottomLeftButton.hidden = NO;
                self.formBottomRightButton.hidden = YES;
                break;
            }
            case FKFormBottomButtonTypeRight:
            {
                self.formBottomLeftButton.hidden = YES;
                self.formBottomRightButton.hidden = NO;
                break;
            }
            case FKFormBottomButtonTypeNone:
            {
                self.formBottomLeftButton.hidden = YES;
                self.formBottomRightButton.hidden = YES;
                break;
            }
                
            default:
                break;
        }
    }
    
}

- (void)setBottomTitles:(NSArray<NSString *> *)bottomTitles {
    if (_bottomTitles != bottomTitles) {
        _bottomTitles = bottomTitles;
        [self setBottomButtonTitle];
    }
}

- (void)setBottomButtonTitle{
    switch (self.formBottomType) {
        case FKFormBottomButtonTypeAll:
        {
            [self.formBottomLeftButton setTitle:self.bottomTitles[0] forState:UIControlStateNormal];
            [self.formBottomRightButton setTitle:self.bottomTitles[1] forState:UIControlStateNormal];
            break;
        }
        case FKFormBottomButtonTypeLeft:
        {
            [self.formBottomLeftButton setTitle:self.bottomTitles[0] forState:UIControlStateNormal];
            break;
        }
        case FKFormBottomButtonTypeRight:
        {
            [self.formBottomRightButton setTitle:self.bottomTitles[1] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - FKFormViewSectionDelegate

// fields字段改变
- (void)section:(FKFormViewSection *)section fieldsDidChange:(NSArray<FKFormViewField *> *)fields {
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FKFormViewFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kFieldCellReuseID forIndexPath:indexPath];
    FKFormViewField *field = self.dataSource[indexPath.section].fields[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.text = @"";
    cell.field = field;
    return cell;
}

// headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FKFormViewSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderReuseID];
    FKFormViewSection *sectionItem = self.dataSource[section];
    headerView.titleLabel.text = sectionItem.title;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    FKFormViewSection *sectionItem = self.dataSource[section];
    if (sectionItem.title != nil) {
        return 35;
    }
    
    return 0;
}


#pragma mark - Event Handlers

// 点击提交按钮
- (void)submitButtonDidTap:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(formView:didSubmitWithSections:)]) {
        [self.delegate formView:self didSubmitWithSections:self.dataSource];
    }
}

- (void)formRightBottomTap:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(formView:tapBottomRight:tapType:)]) {
        [self.delegate formView:self tapBottomRight:self.bottomTitles tapType:self.formBottomType];
    }
}

- (void)formLeftBottomTap:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(formView:tapBottomleft:tapType:)]) {
        [self.delegate formView:self tapBottomleft:self.bottomTitles tapType:self.formBottomType];
    }
    
}

#pragma mark - Helper Methods

-(void)addTableView{
    //add
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self addSubview:tableView];
    
    // setup
    tableView.dataSource            = self;
    tableView.delegate              = self;
    tableView.alwaysBounceVertical  = YES;
    tableView.separatorInset        =UIEdgeInsetsMake(0, 0,0, 0);
    tableView.separatorColor        =FK_TEXTNOTSELECT_COLOR;
    [tableView registerClass:FKFormViewFieldCell.class forCellReuseIdentifier:kFieldCellReuseID];
    [tableView registerClass:FKFormViewSectionHeaderView.class forHeaderFooterViewReuseIdentifier:kSectionHeaderReuseID];
    tableView.backgroundColor = [UIColor clearColor];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 90)];
    tableView.tableFooterView = footerView;
    // layout
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    
    self.tableView = tableView;
    
}

-(void)addSubmitButton{
    // add
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tableView.tableFooterView addSubview:submitButton];
    
    // setup
    [submitButton setBackgroundColor:FK_SELECT_COLOR];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    submitButton.layer.cornerRadius = 5;
    [submitButton addTarget:self action:@selector(submitButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    // layout
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.tableFooterView).offset(15);
        make.right.equalTo(self.tableView.tableFooterView).offset(-15);
        make.height.equalTo(@(40));
        //make.centerY.equalTo(self.tableView.tableFooterView);
        make.bottom.equalTo(self.tableView.tableFooterView.mas_bottom);
    }];
    
    self.submitButton = submitButton;
    
}
-(void)addBottomButton{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tableView.tableFooterView addSubview:rightButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tableView.tableFooterView addSubview:leftButton];
    //setup
    rightButton.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    [rightButton addTarget:self action:@selector(formRightBottomTap:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    leftButton.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    [leftButton addTarget:self action:@selector(formLeftBottomTap:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    //layout
    NSArray  *bottomButtons = @[leftButton,rightButton];
    [bottomButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [bottomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.tableFooterView.mas_top).with.offset(5);
        make.height.equalTo(@(30));
    }];
    
    self.formBottomLeftButton = leftButton;
    self.formBottomRightButton = rightButton;
    
}


-(void)addFormTitleLabel{
    UILabel *formLabel = [[UILabel alloc]init];
    [self addSubview:formLabel];
    
    //set up
    formLabel.textColor = [UIColor whiteColor];
    formLabel.font =[UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
    formLabel.textAlignment = NSTextAlignmentLeft;
    //layout
    [formLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(30));
        make.top.equalTo(self.mas_top);
    }];
    
    self.formTitleLabel = formLabel;
}

#pragma mark - Getter


- (NSMutableArray<FKFormViewSection *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    return _dataSource;
}

@end



#pragma mark - FKFormViewSection

@implementation FKFormViewSection

@synthesize identifier = _identifier;


#pragma mark - Init


- (instancetype)initWithIdentifier:(NSString *)identifier fields:(NSArray<FKFormViewField *> *)fields {
    if (self = [super init]) {
        _identifier = [identifier copy];
        [self.pfields addObjectsFromArray:fields];
    }
    return self;
}

+ (instancetype)sectionWithIdentifier:(NSString *)identifier fields:(NSArray<FKFormViewField *> *)fields {
    return [[FKFormViewSection alloc] initWithIdentifier:identifier fields:fields];
}


#pragma mark - Interfaces


- (void)addField:(FKFormViewField *)field {
    [self.pfields addObject:field];
    
    if ([self.delegate respondsToSelector:@selector(section:fieldsDidChange:)]) {
        [self.delegate section:self fieldsDidChange:self.pfields.copy];
    }
}

- (void)addFields:(NSArray<FKFormViewField *> *)fields {
    [self.pfields addObjectsFromArray:fields];
    
    if ([self.delegate respondsToSelector:@selector(section:fieldsDidChange:)]) {
        [self.delegate section:self fieldsDidChange:self.pfields.copy];
    }
}

- (void)clearFields {
    
    [self.pfields removeAllObjects];
    
    if ([self.delegate respondsToSelector:@selector(section:fieldsDidChange:)]) {
        [self.delegate section:self fieldsDidChange:self.pfields.copy];
    }
}

- (NSArray<FKFormViewField *> *)fields {
    return self.pfields.copy;
}


#pragma mark - Getter


- (NSMutableArray<FKFormViewField *> *)pfields {
    if (_pfields == nil) {
        _pfields = [[NSMutableArray alloc] init];
    }
    
    return _pfields;
}

@end



#pragma mark - FKFormViewField


@implementation FKFormViewField

@synthesize identifier              = _identifier;
@synthesize placeholder             = _placeholder;
@synthesize rightButtonTitle        = _rightButtonTitle;
@synthesize rightButtonDisableTitle = _rightButtonDisableTitle;
@synthesize type                    = _type;


#pragma mark - Interfaces


- (instancetype)initWithType:(FKFormViewFieldType)type identifier:(NSString *)identifier placeholder:(NSString *)placeholder {
    if (self = [super init]) {
        _identifier  = [identifier copy];
        _placeholder = [placeholder copy];
        _type        = type;
    }
    
    return self;
}

- (instancetype)initWithType:(FKFormViewFieldType)type identifier:(NSString *)identifier placeholder:(NSString *)placeholder rightButtonTitle:(NSString *)rightButtonTitle rightButtonDisableTitle:(NSString *)rightButtonDisableTitle {
    if (self = [self initWithType:type identifier:identifier placeholder:placeholder]) {
        _rightButtonTitle        = rightButtonTitle.copy;
        _rightButtonDisableTitle = rightButtonDisableTitle.copy;
    }
    
    return self;
}

+ (instancetype)fieldWithType:(FKFormViewFieldType)type identifier:(NSString *)identifier placeholder:(NSString *)placeholder {
    return [[FKFormViewField alloc] initWithType:type identifier:identifier placeholder:placeholder];
}

+ (instancetype)fieldWithType:(FKFormViewFieldType)type identifier:(NSString *)identifier placeholder:(NSString *)placeholder rightButtonTitle:(NSString *)rightButtonTitle rightButtonDisableTitle:(NSString *)rightButtonDisableTitle {
    return [[FKFormViewField alloc] initWithType:type identifier:identifier placeholder:placeholder rightButtonTitle:rightButtonTitle rightButtonDisableTitle:rightButtonDisableTitle];
}

@end


#pragma mark - NSArray (FKFormView)


@implementation NSArray (FKFormView)

- (FKFormViewSection *)sectionForIdentifier:(NSString *)identifier {
    for (id item in self) {
        if ([item isKindOfClass:FKFormViewSection.class] && [[item identifier] isEqualToString:identifier]) {
            return item;
        }
    }
    
    return nil;
}

- (FKFormViewField *)fieldForIdentifier:(NSString *)identifier {
    for (id item in self) {
        if ([item isKindOfClass:FKFormViewField.class] && [[item identifier] isEqualToString:identifier]) {
            return item;
        }
    }
    
    return nil;
}

@end
