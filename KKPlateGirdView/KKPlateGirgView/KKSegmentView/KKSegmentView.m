//
//  KKSegmentView.m
//  KKToydayNews
//
//  Created by finger on 2017/8/7.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKSegmentView.h"
#import "KKSegmentCollectionCell.h"
#import "KKAddMoreView.h"

static NSString * cellIdentifier = @"cellIdentifier";

@interface KKSegmentView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView ;
@property(nonatomic,strong)KKAddMoreView *addMoreView ;
@property(nonatomic,assign)NSInteger selectedIndex;
@end

@implementation KKSegmentView

- (id)init{
    self = [super init];
    if(self){
        [self setupUI];
        [self bandingEvent];
    }
    return self ;
}

#pragma mark -- 初始化UI

- (void)setupUI{
    self.layer.borderWidth = 0.5 ;
    self.layer.borderColor = [[UIColor blackColor]colorWithAlphaComponent:0.1].CGColor;
    
    [self addSubview:self.collectionView];
    [self addSubview:self.addMoreView];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.addMoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark -- 绑定事件

- (void)bandingEvent{
    @weakify(self);
    [self.addMoreView setAddBtnClickHandler:^{
        @strongify(self);
        if(self.delegate && [self.delegate respondsToSelector:@selector(addMoreSegmentClicked)]){
            [self.delegate addMoreSegmentClicked];
        }
    }];
}

#pragma mark -- UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.segmentItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKSegmentItem *item = [self.segmentItems safeObjectAtIndex:indexPath.row];
    KKSegmentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.item = item ;
    cell.isSelected = (indexPath.row == self.selectedIndex) ;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    KKSegmentItem *item = [self.segmentItems safeObjectAtIndex:indexPath.row];
    self.selectedIndex = indexPath.row ;
    self.curtSelType = item.type;
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectedSegmentItem:)]){
        [self.delegate selectedSegmentItem:item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKSegmentItem *item = [self.segmentItems safeObjectAtIndex:indexPath.row];
    return [KKSegmentCollectionCell titleSize:item.title];
}

#pragma mark -- @property

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumInteritemSpacing = 10 ;
            layout.footerReferenceSize = CGSizeMake(30, 30);
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            [view registerClass:[KKSegmentCollectionCell class] forCellWithReuseIdentifier:cellIdentifier];
            view.delegate = self;
            view.dataSource = self;
            view.backgroundColor = [UIColor clearColor];
            view.showsHorizontalScrollIndicator = NO;
            view;
        });
    }
    return _collectionView;
}

- (KKAddMoreView *)addMoreView{
    if(!_addMoreView){
        _addMoreView = ({
            KKAddMoreView *view = [[KKAddMoreView alloc]init];
            view;
        });
    }
    return _addMoreView;
}

- (void)setSegmentItems:(NSArray *)segmentItems{
    _segmentItems = segmentItems ;
    [self.collectionView reloadData];
    //设置当前选择的板块
    self.curtSelType = self.curtSelType;
}

- (void)setCurtSelType:(KKSegmentType)curtSelType{
    _curtSelType = curtSelType ;
    [self.segmentItems enumerateObjectsUsingBlock:^(KKSegmentItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.type == curtSelType){
            self.selectedIndex = idx ;
            *stop = YES ;
        }
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    NSArray *array = self.collectionView.indexPathsForVisibleItems;
    [self.collectionView reloadItemsAtIndexPaths:array];
    
}

@end
