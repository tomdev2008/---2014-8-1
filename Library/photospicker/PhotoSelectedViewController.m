//
//  PhotoSelectedViewController.m
//  PhotosPickDemo
//
//  Created by dbloong on 14-6-13.
//  Copyright (c) 2014年 dbloong. All rights reserved.
//

#import "PhotoSelectedViewController.h"

@interface PhotoSelectedViewController ()

@end

@implementation PhotoSelectedViewController
{
    NSMutableArray *_selectedALAssets;
    NSMutableArray *_selectedPhotos;
    UIScrollView *_contentView;
    NSMutableArray *_reusableCells;
    
    CGFloat x0;
    CGFloat y0;
    CGFloat dx;
    CGFloat dy;
    CGFloat cellWidth;
    CGFloat cellHeight;
    
    NSInteger startLine;
    NSInteger endLine;
    NSInteger contentOffset;
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
    
    _selectedALAssets = [[NSMutableArray alloc] init];
    _selectedPhotos = [[NSMutableArray alloc] init];

    _reusableCells = [[NSMutableArray alloc ] init];
    
    _contentView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _contentView.delegate = self;
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endSelectPhotos)];
    self.navigationItem.rightBarButtonItem = buttonDone;
    [self.view addSubview:_contentView];
    
    x0 = 0;
    y0 = 5;
    dx = 2;
    dy = 2;
    cellWidth = (self.view.frame.size.width - 3 * dx)/4;
    cellHeight = cellWidth;
    contentOffset = 0;
}

- (void)endSelectPhotos
{
    for (ALAsset *item in _selectedALAssets) {
        [_selectedPhotos addObject:[[UIImage alloc] initWithCGImage:[[item defaultRepresentation] fullResolutionImage]]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    self.compeletionBlock(_selectedPhotos);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadPhotos];
    [_selectedALAssets removeAllObjects];
    [_selectedPhotos removeAllObjects];
}

- (void)loadPhotos
{
    for (UIView *item in [_contentView subviews]) {
        [item removeFromSuperview];
    }
    startLine = 0;
    int i = 0, j = 0;
    for (i = 0; i * 4 + j < _photos.count + 4; i++){
        j = 0;
        for (j = 0; i * 4 + j < _photos.count && j < 4; j++) {
            UIButton *cell = [self getCell];
            cell.tag = i * 4 + j + 1;
            cell.frame = CGRectMake(x0 + j * (dx + cellWidth), y0 + i * (dy + cellHeight), cellWidth, cellHeight);
            ALAsset *photo = _photos[i * 4 + j];
            [cell setBackgroundImage:[[UIImage alloc] initWithCGImage:[photo thumbnail]] forState:UIControlStateNormal];
            [_contentView addSubview:cell];
        }
        if (y0 + i * (dy + cellHeight) + cellHeight > _contentView.frame.size.height + 5 - 64) {
            break;
        }
    }
    endLine = i;
    CGFloat height = y0 + (_photos.count / 4 + (_photos.count % 4 == 0 ? 0 : 1)) * (dy + cellHeight);
    
    [_contentView setContentSize:CGSizeMake(self.view.frame.size.width, height > _contentView.frame.size.height ? height : _contentView.frame.size.height)];
    
}

- (UIButton *)getCell
{
    UIButton *cell = nil;
    if (_reusableCells.count > 0) {
        cell = _reusableCells[0];
        [_reusableCells removeObjectAtIndex:0];
    }else{
        cell = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell setImage:[UIImage imageNamed:@"selectedicon.png"] forState:UIControlStateSelected];
        cell.imageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [cell addTarget:self action:@selector(selectedPhotoWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > contentOffset) {//向上
        float upY = y0 + (cellHeight + dy) *  startLine + cellHeight - scrollView.contentOffset.y;
        if (upY < -5 && startLine >= 0) {
            //移除最上一行
            for (int i = 0; i < 4; i++) {
                UIButton *cell = (UIButton *)[scrollView viewWithTag:startLine * 4 + i + 1];
                [_reusableCells addObject:cell];
                [cell removeFromSuperview];
            }
            startLine++;
        }
        
        float bottomY = y0 + (cellHeight + dy) * (endLine + 1) - scrollView.contentOffset.y;
        if (bottomY < scrollView.frame.size.height + 5) {
            //载入下一行
            for (int i = 0; i < 4 && (endLine + 1) * 4 + i < _photos.count; i++) {
                UIButton *cell = [self getCell];
                cell.tag = (endLine + 1) * 4 + i + 1;
                cell.frame = CGRectMake(x0 + i * (dx + cellWidth), y0 + (endLine + 1) * (dy + cellHeight), cellWidth, cellHeight);
                [cell setBackgroundImage:[[UIImage alloc] initWithCGImage:[_photos[(endLine + 1) * 4 + i] thumbnail]] forState:UIControlStateNormal];
                [scrollView addSubview:cell];
            }
            endLine++;
        }
        
    }else{//向下
        float upY = y0 + (cellHeight + dy) *  (startLine - 1) + cellHeight - scrollView.contentOffset.y;
        //载入嘴上一行
        if (upY > -5 && startLine > 0) {
            for (int i = 0; i < 4; i++) {
                UIButton *cell = [self getCell];
                cell.tag = (startLine - 1) * 4 + i + 1;
                cell.frame = CGRectMake(x0 + i * (dx + cellWidth), y0 + (startLine - 1) * (cellHeight + dy), cellWidth, cellHeight);
                [cell setBackgroundImage:[[UIImage alloc] initWithCGImage:[_photos[(startLine - 1) * 4 + i] thumbnail]] forState:UIControlStateNormal];
                [scrollView addSubview:cell];
            }
            startLine--;
        }
        
        float bottomY = y0 + (cellHeight + dy) * endLine - scrollView.contentOffset.y;
        if (bottomY > scrollView.frame.size.height + 5) {
            for (int i = 0; i < 4 && endLine * 4 + i < _photos.count; i++) {
                UIButton *cell = (UIButton *)[scrollView viewWithTag:endLine * 4 + i + 1];
                [_reusableCells addObject:cell];
                [cell removeFromSuperview];
            }
            endLine--;
        }
    }
    contentOffset = scrollView.contentOffset.y;
}

- (void)selectedPhotoWithButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_selectedALAssets addObject:_photos[sender.tag - 1]];
    }else{
        [_selectedALAssets removeObject:_photos[sender.tag - 1]];
    }
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
