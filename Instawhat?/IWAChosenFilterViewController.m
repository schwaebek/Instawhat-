//
//  IWAChosenFilterViewController.m
//  Instawhat?
//
//  Created by Katlyn Schwaebe on 8/26/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "IWAChosenFilterViewController.h"

@interface IWAChosenFilterViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation IWAChosenFilterViewController
{
    UITextField * postTextField;
    UIImageView * imageView1;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20 , SCREEN_HEIGHT/2)];
        imageView1.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:imageView1];
    }
    return self;
}
- (void)viewDidLoad {
    
    UIView * masterView = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    masterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:masterView];
    
    
    
    UIView * minorView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2, SCREEN_WIDTH -20, 100)];
    minorView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:minorView];
    
    
    postTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT/2) + 10, SCREEN_WIDTH -40, 200)];
    postTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:postTextField];
    
    UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0,500, 320, 70)];
    submitButton.backgroundColor = [UIColor orangeColor];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitPost) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) submitPost
{
    NSString * postInfo = [[NSString alloc] init];
    /// if statement
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setFilteredImage:(UIImage *)filteredImage
{
    _filteredImage = filteredImage;
    imageView1.image = filteredImage;
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
