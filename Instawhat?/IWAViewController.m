//
//  IWAViewController.m
//  Instawhat?
//
//  Created by Katlyn Schwaebe on 8/21/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

#import "IWAViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IWAFilterViewController.h"

@interface IWAViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation IWAViewController
{
    UIImagePickerController * imagePicker;
    NSMutableArray * photos;
    ALAssetsLibrary * library;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    photos = [@[]mutableCopy];
	// Do any additional setup after loading the view, typically from a nib.
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType= UIImagePickerControllerSourceTypeCamera;
    imagePicker.view.frame = self.view.frame;
    imagePicker.showsCameraControls = YES;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    imagePicker.delegate = self;
    [self.view addSubview:imagePicker.view];
    //imagePicker.view.alpha = 0; (takes picture automatically upon opening camera
    [self addChildViewController:imagePicker];
    
    imagePicker.view.frame = CGRectMake(0, 0, 320, 320);
    
    UIButton * takePictureButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 370, 100, 100)];
    takePictureButton.backgroundColor = [UIColor blackColor];
    [takePictureButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:takePictureButton];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    UICollectionView * photoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 320, 320, [UIScreen mainScreen].bounds.size.height - 320)collectionViewLayout:layout];
    photoCollection.dataSource = self;
    photoCollection.delegate = self;
    [photoCollection registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:photoCollection];
    
    library = [[ALAssetsLibrary alloc]init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            NSLog (@"type %@",[result valueForProperty:ALAssetPropertyType]);
            if(result)[photos addObject:result];
            [photoCollection reloadData];
            
        }];
        
    } failureBlock:^(NSError *error) {
        
    }];
   
}
-(void)takePicture
{
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
    [imagePicker takePicture];
    //});
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photos.count;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ALAsset * photo = photos[indexPath.item];
    UIImageView * thumbnailView = [[UIImageView alloc] initWithFrame:cell.bounds];
    thumbnailView.image = [UIImage imageWithCGImage:photo.thumbnail];
    [cell.contentView addSubview:thumbnailView];
   
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UIImageView * bigView = [[UIImageView alloc]initWithFrame:imagePicker.view.frame];
    ALAsset * photo = photos[indexPath.item];
    ALAssetRepresentation * representation = photo.defaultRepresentation;
    
//    bigView.image = [UIImage imageWithCGImage:representation.fullResolutionImage];
//    [self.view addSubview:bigView];
    
    // push viewcontroller
    [self showFilterWithImage:[UIImage imageWithCGImage:representation.fullResolutionImage]];
}
- (UIImage *)normalizedImage:(UIImage*)normalImage
{
    if (normalImage.imageOrientation == UIImageOrientationUp) return normalImage;
    
    UIGraphicsBeginImageContextWithOptions(normalImage.size, NO, normalImage.scale);
    [normalImage drawInRect:(CGRect){0, 0, normalImage.size}];
    UIImage * normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * fixedImage = [self normalizedImage:info[UIImagePickerControllerOriginalImage]];
    
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    imageView.image= info [UIImagePickerControllerOriginalImage];
//    [self.view addSubview:imageView];
    [self showFilterWithImage: fixedImage];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES; 
}
-(void)showFilterWithImage:(UIImage *)image
{
    IWAFilterViewController * filterVC = [[IWAFilterViewController alloc]init];
    filterVC.originalImage = image;
    [self.navigationController pushViewController:filterVC animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // push viewcontroller
    // Dispose of any resources that can be recreated.
}






@end
