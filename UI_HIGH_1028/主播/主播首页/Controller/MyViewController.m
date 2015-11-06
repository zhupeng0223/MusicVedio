//
//  MyViewController.m
//  UI_HIGH_1028
//
//  Created by lanou on 15/11/5.
//  Copyright (c) 2015年 xxl. All rights reserved.
//

#import "MyViewController.h"
#import "MyFirstCell.h"
#import "UIColor+AddColor.h"
#import "UIImageView+WebCache.h"
@interface MyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *firstArr;

@property (nonatomic,strong) NSMutableArray *secondArr;
@property (nonatomic,strong) NSMutableArray *secondImgArr;

@property (nonatomic,strong) NSMutableArray *thirdArr;
@property (nonatomic,strong) NSMutableArray *thirdImgArr;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, -180, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 180)) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view bringSubviewToFront:self.button];
    
    
    [self.view bringSubviewToFront:(UIView *)self.picControl];
    

    self.secondArr = [@[@"关注过的",@"赞过的"] mutableCopy];
    self.thirdArr = [@[ @"定时关闭",@"清除缓存"] mutableCopy];
    
    self.secondImgArr = [@[@"attention",@"praise"] mutableCopy];
    self.thirdImgArr = [@[@"time",@"clearCache"] mutableCopy];
    
    self.tableView.backgroundColor = [UIColor silverColor];
    self.tableView.alpha = 0.8;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    __block __weak id observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"ImageCacheChange" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        if (observer == nil) {
//            return ;
//        }
//        [self.tableView reloadData];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.secondArr.count;
    } else {
        return self.thirdArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 400;
    } else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        MyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyFirstCell" owner:nil options:nil] lastObject];
        }
        
        cell.textLabel.text = self.firstArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
    
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        }
        if (indexPath.section == 1) {
            
            cell.textLabel.text = self.secondArr[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:self.secondImgArr[indexPath.row]];
        }else if (indexPath.section == 2) {
            cell.textLabel.text = self.thirdArr[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:self.thirdImgArr[indexPath.row]];

        }
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 2 && indexPath.row == 1) {
            cell.detailTextLabel.text = [self getImageCacheSize];
        } else {
            UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropBtnImg"]];
            cell.accessoryView = imageV;
        }
        return cell;
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空缓存" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [[SDImageCache sharedImageCache] clearDisk];
                    [self.tableView reloadData];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [self presentViewController:alertController animated:YES completion:nil
                 ];

            }
                break;
        }
    }
    
}

#pragma mark - 计算缓存
- (NSString *)getImageCacheSize {
    NSString *title = nil;
    NSUInteger size = [SDImageCache sharedImageCache].getSize;
    if (size > 1024*1024) {
        CGFloat floatSize = size / 2048.0;
        title = [NSString stringWithFormat:@"%.fM",floatSize];
    } else if (size > 1024) {
        CGFloat floatSize = size / 1024.0;
        title = [NSString stringWithFormat:@"%.fKB",floatSize];
    } else if (size > 0) {
        title = [NSString stringWithFormat:@"%ldb",size];
    }
    return title;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
