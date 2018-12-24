//
//  ViewController.m
//  QQ个性化可拉伸头部控件
//  功能介绍：
//  1、TableView下拉放大图片
//  2、TableView上拉图片往上移动，导航栏颜色由浅变深
//
//  实现方案：
//  1、导航栏用UIVIew实现，方便颜色变化
//  2、图片加载到self.view中
//  3、TableView通过headerView的透明来占位，通过实现scroll的协议来改变图片的大小、位置和导航栏位置的变化
//
//
//
//  Created by yangfeng on 2018/12/24.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    UIView *navBar;
    UIImageView *bgView;
    CGRect originalFrame;
}

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, copy) NSArray *tabArray;

@end

static const CGFloat ratio = (1200.0f / 1920.0f);


@implementation ViewController

- (NSArray *)tabArray {
    if (!_tabArray) {
        _tabArray = @[@"q",@"w",@"q",@"w",@"q",@"w",@"q",@"w"
                      ,@"q",@"w",@"q",@"w",@"q",@"w",@"q",@"w"
                      ,@"q",@"w",@"q",@"w",@"q",@"w",@"q",@"w"];
    }
    return _tabArray;
}

- (void)loadView {
    [super loadView];

    bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"up10"]];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    navBar = [[UIView alloc]init];
    navBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navBar];
    
    self.tabView = [[UITableView alloc]init];
    self.tabView.backgroundColor = [UIColor clearColor];
    self.tabView.dataSource = self;
    self.tabView.delegate = self;
    [self.view addSubview:self.tabView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController setNavigationBarHidden:YES];

    bgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) * ratio);
    originalFrame = bgView.frame;
    navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64);
    self.tabView.frame = CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 64.0f);

    if (self.tabView.tableHeaderView.subviews.count == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tabView.frame), CGRectGetHeight(bgView.frame) - 64.0f)];
        view.backgroundColor = [UIColor clearColor];
        self.tabView.tableHeaderView = view;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat headerHeight = CGRectGetHeight(bgView.frame) - 64.0;
    
    if (yOffset < headerHeight) {
        CGFloat apl = yOffset / headerHeight;
        navBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:apl];
    }
    else {
        navBar.backgroundColor = [UIColor whiteColor];
    }
    
    if (yOffset > 0) {
        bgView.frame = ({
            CGRect frame = originalFrame;
            frame.origin.y = originalFrame.origin.y - yOffset;
            frame;
        });
    }
    else {
        bgView.frame = ({
            CGRect frame = originalFrame;
            frame.size.height = originalFrame.size.height - yOffset;
            frame.size.width = frame.size.height / ratio;
            frame.origin.x = originalFrame.origin.x - (frame.size.width - originalFrame.size.width) / 2.0;
            frame;
        });
    }
    
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tabArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.tabArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row = %@",self.tabArray[indexPath.row]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
