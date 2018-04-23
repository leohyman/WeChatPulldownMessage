//
//  LZTestView.m
//  SmallChatGame
//
//  Created by vv-lvzhao on 2018/4/22.
//  Copyright © 2018年 LvZhao. All rights reserved.
//

#import "LZTestView.h"

@interface LZTestView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView * headView; //headView loading

@property (nonatomic,assign) BOOL hasPrePage; //是否还有历史消息

@property (nonatomic,assign) BOOL isPulldownLoading; //开始加载历史消息

@property (nonatomic,assign) BOOL isEenDraggingAnimation; //加载历史消息动画

@property (nonatomic,strong) NSMutableArray *dataArray; //数据源

@end

@implementation LZTestView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self setupView];
    }
    return self;
}


//创建UI
- (void)setupView{
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
   
    self.dataArray = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < 15; i++){
        [self.dataArray addObject:@"测试信息"];
    }
    self.hasPrePage = YES;
    [self.tableView reloadData];
    if(self.dataArray.count> 0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } else{
        self.hasPrePage = NO;
        self.tableView.tableHeaderView = nil;
    }
    
}



#pragma mark -lanjiazai
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_SCREENWIDTH,
                                                                      (K_Device_Is_iPhoneX) ? K_SCREENHEIGHT - 34 - K_NAVHEIGHT:
                                                                      K_SCREENHEIGHT  - K_NAVHEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
- (UIView *)headView{
    if(!_headView){
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = [UIColor clearColor];
        _headView.frame = CGRectMake(0, 0, K_SCREENWIDTH, K_HeadViewHeight);
        // loading
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loading.center = CGPointMake(K_SCREENWIDTH * 0.5, K_HeadViewHeight * 0.5);
        [loading startAnimating];
        [_headView addSubview:loading];
    }
    return _headView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UIScrollViewDelegate
//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"偏移量%f",scrollView.contentOffset.y);
    if (self.isPulldownLoading && self.hasPrePage) {
        self.tableView.tableHeaderView = self.headView;
        self.isPulldownLoading = NO;
    }
    
}

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    self.isPulldownLoading = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y <= .0f && !self.isPulldownLoading&&!self.isEenDraggingAnimation){
        self.isEenDraggingAnimation = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if(scrollView.contentOffset.y <= K_HeadViewHeight){
                [self pulldownLoad];
            }
            self.isEenDraggingAnimation = NO;
        });
    }
    
}


#pragma mark - 下拉历史消息
- (void)pulldownLoad
{
    if(self.isPulldownLoading)return;
    self.isPulldownLoading = YES;
    
    //获取历史消息
    NSArray * histortMessages = [self loadHistoryMessage];
    
    self.tableView.tableHeaderView = nil;
    self.isPulldownLoading = NO;
    
    
    if ([histortMessages count] < 15) {
        self.hasPrePage = NO;
        self.tableView.tableHeaderView = nil;
    }
    //插入消息
    [self insertOldMessages:histortMessages];
    
    
}
//加载历史消息
- (void)insertOldMessages:(NSArray *)oldMessages  {
    
    if([oldMessages count] > 0 && self.tableView.contentOffset.y <= 10.0f){
        @synchronized(self){
         
            CGFloat offsetOfButtom = self.tableView.contentSize.height - self.tableView.contentOffset.y;
            
            [self.dataArray insertObjects:oldMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[oldMessages count])]];
            
            [self.tableView reloadData];
            
            self.tableView.contentOffset = CGPointMake(0.0f, self.tableView.contentSize.height - offsetOfButtom - K_HeadViewHeight);
            
        }
    }
}

#pragma makr - 获取历史消息
- (NSArray *)loadHistoryMessage{
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
//    self.pulldownCount ++;
    for(int i = 0 ; i < 15; i++){
        [array addObject:@"测试"];
    }
    return array;
}

/*
- (instancetype)initWithModel:(LZChatMessageViewModel *)viewModel
{
    self = [super init];
    if (self) {
        
        self.viewModel = viewModel;
        //是否显示发送者的名字
        @weakify(self)
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:K_ShowGroupNickNameNotificationName object:nil]subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self)
            [self notificationShowSendName:x];
        }];
        
        [self.viewModel setMessageBlock:^(LZChatMessageType type, id object) {
            @strongify(self)
            [self reloadMessageType:type objetc:object];
        }];
        //获取聊天信息
        [self.viewModel getChatReceiveMessage];
        self.hasPrePage = YES;
        
    }
    return self;
}

#pragma mark -- 刷新UI
- (void)reloadMessageType:(LZChatMessageType)type objetc:(id)object{
    
    switch (type) {
        case LZChatMessageTypeReceiveData: //收发消息
        {
            [self.tableView reloadData];
            if(self.viewModel.dataArray.count> 0){
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.viewModel.dataArray.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            } else{
                self.hasPrePage = NO;
                self.tableView.tableHeaderView = nil;
            }
        }
            break;
        case LZChatMessageTypeHistoryMessage: //历史消息
        {
            NSMutableArray * histortMessages = object;
            
            self.tableView.tableHeaderView = nil;
            self.isPulldownLoading = NO;
            
            if ([histortMessages count] < 20) {
                self.hasPrePage = NO;
                self.tableView.tableHeaderView = nil;
            }
            //插入消息
            [self insertOldMessages:histortMessages];
            
        }
            break;
            
            
            self.gamblingMenuView.viewModel = self.viewModel;
            self.lotteryResultView.viewModel = self.viewModel;
            self.financeView.viewModel = self.viewModel;
            
            
            //请求开奖的信息,,, 要传值了!!!
        default:
            break;
    }
    
    
}

//是否显示发送者名字
- (void)notificationShowSendName:(NSNotification *)info{
    for(LZChatMessageModel * messageModel in self.viewModel.dataArray){
        messageModel.emMessage = messageModel.emMessage;
    }
    [self.tableView reloadData];
}


#pragma mark - 处理通知事件--回调


#pragma mark - menu回调
- (void)menuButtonClick:(UIButton *)button{
    switch (button.tag) {
        case 10:
        {
            //明细
            LZGamblingDetailViewController * gamblingDetailVC = [[LZGamblingDetailViewController alloc]init];
            gamblingDetailVC.gamblingType = self.viewModel.groupModel.gamblingType;
            [[LZTool topViewController].navigationController pushViewController:gamblingDetailVC animated:YES];
            
        }
            break;
        case 11:
        {   //走势
            LZTrendDetailViewController * trendDetailVC = [[LZTrendDetailViewController alloc]init];
            trendDetailVC.gamblingType = self.viewModel.groupModel.gamblingType;
            [[LZTool topViewController].navigationController pushViewController:trendDetailVC animated:YES];
            
        }
            break;
        case 12:
        {
            //开奖
            self.lotteryResultView.isShow = !self.lotteryResultView.isShow;
            if (self.lotteryResultView.isShow) {
                [self dismissChatKeyboard];
            }
        }
            break;
        case 13:
        {
            //规则
            
            
        }
            break;
        case 14:
        {
            //财务
            self.financeView.isShow = !self.financeView.isShow;
            if(self.financeView.isShow){
                [self dismissChatKeyboard];
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.tableView.y = LZGet(205);
                } completion:^(BOOL finished) {
                    
                }];
                
            } else {
                [UIView animateWithDuration:0.4 animations:^{
                    self.tableView.y = LZGet(60);
                    
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        }
            break;
        default:
            break;
    }
}

//删除接收消息的回调
- (void)removeReceiveMessageDelegate{
    [self.viewModel removeReceiveMessageDelegate];
}

//创建UI
- (void)setupView{
    [self addSubview:self.gamblingMenuView];
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    [self addSubview:self.boxView];
    [self addSubview:self.financeView]; //财务
    [self addSubview:self.lotteryResultView]; //开奖页面
    
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissChatKeyboard)];;
    [self.tableView addGestureRecognizer:tapGes];
}

#pragma mark - 消失keyboard
- (void)dismissChatKeyboard{
    self.boxView.keyboardIsVisiable = NO;
    [self endEditing:YES];
}


#pragma mark - LZChatBoxViewDelegate
- (void)updateChatBoxViewY:(CGFloat)chatBoxY{
    NSLog(@"chatBoxY%f",chatBoxY);
    self.tableView.height = chatBoxY - LZGet(60);
    if(self.viewModel.dataArray.count > 0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.viewModel.dataArray.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


//开始编辑
- (void)chatBoxViewDidBeginEditing{
    //开奖
    if(self.lotteryResultView.isShow){
        self.lotteryResultView.isShow = NO;
    }
    //财务
    if(self.financeView.isShow){
        self.financeView.isShow = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.y = LZGet(60);
        } completion:^(BOOL finished) {
        }];
    }
    
}

- (void)sendTextMessage:(NSString *)message{
    
    NSLog(@"message%@",message);
    [self.viewModel sendMessageText:message];
    
}




// any offset changes

- (LZGamblingMenuView *)gamblingMenuView{
    if(!_gamblingMenuView){
        _gamblingMenuView = [[LZGamblingMenuView alloc]initWithFrame:CGRectMake(0, 0, K_SCREENWIDTH, LZGet(60))];
        _gamblingMenuView.backgroundColor = LZWhiteColor;
        @weakify(self)
        [_gamblingMenuView setMenuClickBlock:^(UIButton *btn) {
            @strongify(self)
            [self menuButtonClick:btn];
        }];
    }
    return _gamblingMenuView;
}

//工具
- (LZChatBoxView *)boxView{
    if(!_boxView){
        _boxView = [[LZChatBoxView alloc]initWithFrame:CGRectMake(0, (K_Device_Is_iPhoneX) ? K_SCREENHEIGHT - 34 - K_NAVHEIGHT - LZGet(50) : K_SCREENHEIGHT  - K_NAVHEIGHT - LZGet(50), K_SCREENWIDTH, LZGet(50))];
        _boxView.delegate = self;
        _boxView.gamblingType = self.viewModel.groupModel.gamblingType;
    }
    return _boxView;
    
}

//财务
- (LZFinanceView *)financeView{
    if(!_financeView){
        _financeView = [[LZFinanceView alloc]init];
        _financeView.frame = CGRectMake(0, -LZGet(300), K_SCREENWIDTH, LZGet(140));
        @weakify(self)
        [[_financeView.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self menuButtonClick:x];
        }];
        
    }
    return _financeView;
}

//财务
- (LZLotteryResultView *)lotteryResultView{
    if(!_lotteryResultView){
        _lotteryResultView = [[LZLotteryResultView alloc]init];
        _lotteryResultView.frame = CGRectMake(0, -LZGet(700), K_SCREENWIDTH, LZGet(600));
        
    }
    return _lotteryResultView;
}

@end


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
