//
//  PhotosPickerViewController.m
//  PhotosPickDemo
//
//  Created by dbloong on 14-6-13.
//  Copyright (c) 2014年 dbloong. All rights reserved.
//

#import "PhotosPickerViewController.h"

@interface PhotosPickerViewController ()

@end

@implementation PhotosPickerViewController
{
    UITableView *_table;
    ALAssetsLibrary *_photoLibrary;
    NSMutableArray *_photoGroups;
    NSMutableArray *_photoGroupsInfo;
    NSMutableArray *_images;
    PhotoSelectedViewController *_photoSelectedView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;  // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Photos";
    _photoGroups = [[NSMutableArray alloc] init];
    _photoGroupsInfo = [[NSMutableArray alloc] init];
    _photoLibrary = [[ALAssetsLibrary alloc] init];
    _photoSelectedView = [[PhotoSelectedViewController alloc] init];
    _photoSelectedView.compeletionBlock = self.compeletionBlock;
    [self loadPhotoGroups];

    _table = [[UITableView alloc] initWithFrame:self.view.frame];
    _table.delegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)cancelPick
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.compeletionBlock([[NSArray alloc] init]);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_table deselectRowAtIndexPath:[_table indexPathForSelectedRow] animated:YES];
}

- (void)loadPhotoGroups
{
    _images = [[NSMutableArray alloc ] init];
    [_photoLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != NULL) {
            [_photoGroups insertObject:group atIndex:0];
            [_photoGroupsInfo addObject:[[NSMutableArray alloc] init]];
        }else{
            [_table reloadData];
            [self getAlbumInfoWithIndex:0];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"loadPhotosInfosInfol error");
    }];
}

- (void)getAlbumInfoWithIndex:(NSInteger)groupIndex
{
    [_photoGroups[groupIndex] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != NULL) {
            [_photoGroupsInfo[groupIndex] addObject:result];
        }else{
            [_table reloadData];
            if (groupIndex + 1 < _photoGroupsInfo.count) {
                [self getAlbumInfoWithIndex:groupIndex + 1];
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"groupCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *borderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 69, 73)];
        borderView.image = [UIImage imageNamed:@"photoborder_3.png"];
        borderView.tag = 9;
        borderView.alpha = 0.7;
        [cell.imageView addSubview:borderView];
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    int count = 0;
    for (ALAsset *item in _photoGroupsInfo[indexPath.row]) {
        if (count < 3) {
            [images insertObject:[UIImage imageWithCGImage:item.thumbnail] atIndex:0];
            count++;
        }
    }
    while (images.count < 3) {
        [images insertObject:[[UIImage alloc] init] atIndex:0];
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(69, 73), NO, 3);
    for (int i = 0; i < 3; i++) {
        [images[i] drawInRect:CGRectMake(2 * (2 - i), i * 2, 69 - 4 * (2 - i), 73 - i * 2)];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    cell.imageView.image = image;
    UIGraphicsEndImageContext();
    
    UIImageView *imgv = (UIImageView *)[cell.imageView viewWithTag:9];
    imgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"photoborder_%d.png", count]];
    
    ALAssetsGroup *group = _photoGroups[indexPath.row];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [group numberOfAssets]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _photoSelectedView.photos = _photoGroupsInfo[indexPath.row];
    _photoSelectedView.title = [NSString stringWithFormat:@"%@", [_photoGroups[indexPath.row] valueForProperty:ALAssetsGroupPropertyName]];
    [self.navigationController pushViewController:_photoSelectedView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photoGroups.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
