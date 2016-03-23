//
//  ViewController.m
//  WechatArticle
//
//  Created by 找房 on 15/12/8.
//  Copyright © 2015年 zhaofang. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "WeichatArticleModel.h"

#import "UIImageView+WebCache.h"

#import "WebController.h"

#import "CoverCell.h"

#import "NaviHeader.h"

#import "MJRefresh.h"

#import "MJChiBaoZiHeader.h"

#import "MCKScanQRImage.h"

#import "WXApi.h"

#import "DGActivityIndicatorView.h"

#import "LanchImageView.h"


#import "FMDBManager.h"

#import "MBProgressHUD+Add.h"
#include <AudioToolbox/AudioToolbox.h>
#include <CoreFoundation/CoreFoundation.h>

#import <JMessage/JMessage.h>



// Define a callback to be called when the sound is finished
// playing. Useful when you need to free memory after playing.

typedef NS_ENUM(NSInteger, URLType) {
    
    GeneURL = 0,
    WeiXinURL = 1,
    OtherURL = 2
};


//#import "YCRefreshControl.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NaviHeaderDelegate,MCKScanDeleget,UISearchBarDelegate,UIAlertViewDelegate>


{

    NSMutableArray * listArray ;
    UITableView * mainTable;
    
    UIView * Assew;
    
    NSInteger KeyType;
    
    NSString * key ;
    NSInteger  currentPage;
    
    
    NaviHeader * navi;
    UISearchBar * searchBar;
    BOOL isBusy;
    
    DGActivityIndicatorView * activityView;
    
    BOOL isLaunch;
    
    
    BOOL isGonnaScan;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FMDBManager creatTable];
    
    [self prepare2PushLocalMessage];

    currentPage = 1;
    listArray = [[NSMutableArray alloc]init];
    
    
    [self makeView];
    
    
    
   // [self getListWithClear:YES];
    navi = [[NaviHeader alloc]init];
    
    navi.block = ^(NSInteger index){
    
    
        NSLog(@"my block");
    
    };
 
    
    [navi setDelegate:self];
    
        [navi changeSate:YES withBlock:^(NSInteger index) {
            
            
        }];

    [navi try2NaviWithCancelBlock:^(BOOL isCancel, NSInteger lastIndex) {

    }];
       
    [self.navigationItem setTitleView:navi];
    
    
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        
        NSArray * convArr = resultObject;
        
        for (JMSGConversation * conv in convArr) {
            
            [conv clearUnreadCount];
            
            
            
        }
        
        
    }];


}
-(void) viewWillAppear:(BOOL)animated{

    if(isLaunch){
    
        
        [mainTable reloadData];
    
    }else{
    
        isLaunch = YES;
        
        
        LanchImageView * la = [[LanchImageView alloc]init];
        [la lanchAtSreen];
    
    
    }
    


}
-(void) makeView{

    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    
    
    [mainTable setDelegate: self];
    [mainTable setDataSource:self];
    [self.view addSubview:mainTable];
    

    mainTable.mj_header = [MJRefreshStateHeader  headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];

    
    
    self.title = @"热门文章";
    

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage * buttonImage =  [UIImage imageNamed:@"locationSharing_icon_back"];
    [button setImage:[UIImage imageNamed:@"locationSharing_icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(go2Top) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - buttonImage.size.width - 10, [UIScreen mainScreen].bounds.size.height - buttonImage.size.height - 30 -64, buttonImage.size.width, buttonImage.size.height)];
    
    [self.view addSubview:button];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"LLHomeScan"] style:UIBarButtonItemStylePlain target:self action:@selector(gonnaScan)];
    
    [self.navigationItem setLeftBarButtonItem:left];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"LLHomeSearch"] style:UIBarButtonItemStylePlain target:self action:@selector(gonnaSearch)];


    [self.navigationItem setRightBarButtonItem:right];
}
-(void) gonnaScan{
    
    [searchBar resignFirstResponder];
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        [MBProgressHUD showError:@"摄像头不可用" toView:self.view];
    
        return;
    
    }
    
    if(!isGonnaScan){

    MCKScanQRImage * scan = [[MCKScanQRImage alloc]init];

        isGonnaScan = YES;
        
        
    [[UIApplication sharedApplication].keyWindow addSubview:scan];

    scan.delegate = self;
        
    }
    
    
    
    
}
-(void) gonnaSearch{

    
    if(searchBar ==nil){
    
        searchBar = [[UISearchBar alloc]init];
        [searchBar setPlaceholder:@"输入关键字以检索"];
        [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchField"] forState:UIControlStateNormal];
        [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [searchBar setTintColor:[UIColor colorWithRed:0 green:126/255.0f blue:1 alpha:1]];
        [searchBar setDelegate:self];
    
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        if(navi.isStateSelect ){
            key = @"";
        searchBar.text = @"";
        }else{
        
            [searchBar becomeFirstResponder];
        
        }
    
        
        [self.navigationItem setTitleView:navi.isStateSelect?navi:searchBar];
        
        [[self.navigationItem rightBarButtonItem] setImage:[UIImage imageNamed:navi.isStateSelect? @"LLHomeSearch" :@"ff_IconQRCode"]];
        
        
    }];
    
    [navi changeState:!navi.isStateSelect];
    

}
-(void) go2Top{

    [mainTable setContentOffset:CGPointZero animated:YES];


}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1f;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1f;
}
-(void) refresh{


    [self getListWithClear:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSLog(@"内存清理");
    [[SDImageCache sharedImageCache] clearMemory];
    // Dispose of any resources that can be recreated.
}
-(void) getListWithClear:(BOOL) clear{
    
    
    if(isBusy){
    
        return;
    }
    if(clear){
        
        
        if(activityView == nil){
        
        
            activityView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeTwoDots tintColor:[UIColor orangeColor] size:32.0f];
            [self.view addSubview:activityView];
        
        }
        
        
        
        
        [activityView setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2.0f, [UIScreen mainScreen].bounds.size.height /2.0f)];
        
        [activityView startAnimating];
        
        
    
        currentPage =1;
    }
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    [manager.requestSerializer setValue:@"14396d2b59c87900ed582cfdaff5b157" forHTTPHeaderField:@"apikey"];

     NSString * CKey = (!key || [key isEqualToString:@""])?@"":key;
    
    NSDictionary * paraMs = @{@"typeId":[NSString stringWithFormat:@"%ld", [CKey isEqualToString:@""] ?  KeyType:0],@"page":[NSString stringWithFormat:@"%ld",currentPage],@"key":CKey};
    
   
    
    isBusy = YES;
    [manager GET:@"http://apis.baidu.com/showapi_open_bus/weixin/weixin_article_list" parameters:paraMs success:^(AFHTTPRequestOperation *operation, id responseObject) {
        isBusy = NO;
        //[self debugger:responseObject];
        
        
        
        if(clear){
            
            
            [activityView stopAnimatingAfter:0.5f];
           // [activityView removeFromSuperview];
        
       [mainTable.mj_header endRefreshing];
        }
        NSDictionary * dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        if([dict[@"showapi_res_code"] unsignedIntegerValue] == 0){
        
            NSArray * list  = [[dict[@"showapi_res_body"] objectForKey:@"pagebean"] objectForKey:@"contentlist"];
            
            if(currentPage ==1){
                
                
                
                [listArray removeAllObjects];
                
                
                [mainTable setContentOffset:CGPointZero];
                
            }
            
            if(list.count > 0){
                for (NSDictionary * dict  in list) {
                    
                    WeichatArticleModel * model =      [[WeichatArticleModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                    
                    
                    [listArray addObject:model];
                    
                    
                }
                currentPage ++;
                
                
            }else{
                
                
            }
            
            
            
            
            [mainTable reloadData];
        
        
        
        
        }else{
        
        
        
            NSLog(@"请求参数%@",paraMs);
        
        
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [mainTable.mj_header endRefreshing];
        if(clear){
        
        [activityView stopAnimatingAfter:0.5f];
            [activityView removeFromSuperview];
        
        }
        
        isBusy = NO;
    }];







}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return listArray.count;


}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{


    return 1;
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * ID = @"UD";
    
    
    CoverCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell ==nil){
    
    
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CoverCell" owner:nil options:0] lastObject];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    WeichatArticleModel * model = listArray[indexPath.row];
    
    
    
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.contentImg] placeholderImage:[UIImage imageNamed:@"PicDefault"]];
    [cell.titleLabel setText:model.title];
    
    
    
    if([FMDBManager isArticleExists:model.url]){
    
        [cell.titleLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
    
    
    
    }else{
    
        [cell.titleLabel setTextColor:[UIColor blackColor]];
    
    }
    
    
        
    [cell.deslabel setText:[NSString stringWithFormat:@"%@ %@ ",model.userName,model.typeName]];
    return cell;

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 128.0f;

}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [searchBar resignFirstResponder];
    
    WeichatArticleModel * model = listArray[indexPath.row];
    
    
    
    [FMDBManager insertModel:model];
    

    
    WebController * WebVC = [[WebController alloc]init];
    [WebVC setModel:model];
    [self.navigationController pushViewController:WebVC animated:YES];
}
-(void) naviheaderclickedWithType:(NSInteger)type{

    KeyType = type;
    
    [self getListWithClear:YES];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if( scrollView.contentSize.height < scrollView.contentOffset.y  + scrollView.bounds.size.height +64 ){
    
    
        [self getListWithClear:NO];
    
    }else if(scrollView.contentOffset.y < -44){
    
        //[self getListWithClear:YES];
    
    
    
    }



}
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [searchBar resignFirstResponder];


}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{



    [self.navigationItem setTitleView:navi];



}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBarX{

    

    key = searchBarX.text;
    [self getListWithClear:YES];
    [searchBarX resignFirstResponder];

}
-(void) scanCancel{

    isGonnaScan = NO;

}
-(void) scanResult:(NSString *)result{

       NSLog(@"%@",result);
    
    isGonnaScan = NO;
    
    if(result&& [result isKindOfClass:[NSString class]] && [result hasPrefix:@"http"]){
        
        NSLog(@"%@",result);
        
        if([result rangeOfString:@"weixin.qq.com"].location != NSNotFound){
        
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"这是一个微信链接" message:@"是否打开微信扫码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开微信", nil];
            
            alert.tag = WeiXinURL;
            
            [alert show];
            
        
            NSLog(@"这是一个微信链接，建议用微信扫描");

        
        }
        
        else if ([result hasPrefix:@"http://qm.qq.com"]){
        
        
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"这是一个QQ链接" message:@"请使用QQ扫码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        
            alert.tag = OtherURL;
            
            [alert show];
            
        }else if ([result hasPrefix:@"http://weibo.cn"]){
        
        
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"这是一个微博链接" message:@"请使用微博扫码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = OtherURL;
            [alert show];

        }
        else{
            NSLog(@"++++++扫描结果：%@",result);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
        }
    }

}
-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if(alertView.tag == WeiXinURL){
        if(buttonIndex!= 0){
            [WXApi openWXApp];
        }
    }
}
-(void) debugger:(NSData *) response {

    NSLog(@"%@:%@",[self class],[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]) ;

}
-(void) prepare2PushLocalMessage{

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //本地推送
//        UILocalNotification*notification = [[UILocalNotification alloc]init];
//        NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
//        if (notification != nil) {
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:12];
//            notification.timeZone = [NSTimeZone defaultTimeZone];
//            notification.repeatInterval = 0;
//            notification.soundName = @"appointment.mp3";
//            notification.alertBody = @"今天又有新段子喽！";
//            notification.applicationIconBadgeNumber = 0;
//            NSDictionary*info = [NSDictionary dictionaryWithObject:@"we文摘" forKey:@"name"];
//            notification.userInfo = info;
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//            
//            
//            
//            
//        }
//    });
//    
//    [UILocalNotification cancelPreviousPerformRequestsWithTarget:self];


   // NSMutableArray * notiArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    
   // [notiArr removeAllObjects];
}



-(void) dealloc{
    
    [mainTable setContentOffset:CGPointMake(0, 0)];
    [mainTable removeFromSuperview];
    [mainTable setContentOffset:CGPointZero];


}
@end
