//
//  LongPressFlowLayout.m
//  SchoolIM
//
//  Created by yangqingluo on 16/6/11.
//  Copyright © 2016年 yangqingluo. All rights reserved.
//

#import "LongPressFlowLayout.h"

static NSString *kDecorationReuseIdentifier = @"section_background";
static NSString * const kLXCollectionViewKeyPath = @"collectionView";

@interface LongPressFlowLayout ()

@property (assign, nonatomic, readonly) id<LongPressCollectionViewDelegateFlowLayout> delegate;

@end

@implementation LongPressFlowLayout

- (void)setupCollectionView {
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleLongPressGesture:)];
    _longPressGestureRecognizer.delegate = self;
    
    // Links the default long press gesture recognizer to the custom long press gesture recognizer we are creating now
    // by enforcing failure dependency so that they doesn't clash.
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
}

- (void)tearDownCollectionView {
    // Tear down long press gesture
    if (_longPressGestureRecognizer) {
        UIView *view = _longPressGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer.delegate = nil;
        _longPressGestureRecognizer = nil;
    }
    
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
    
    switch(gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:currentIndexPath];
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
        }
            break;
            
        default:
            break;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:kLXCollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver:self forKeyPath:kLXCollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [self tearDownCollectionView];
    [self removeObserver:self forKeyPath:kLXCollectionViewKeyPath];
}

//返回自定义的布局属性类
+ (Class)layoutAttributesClass {
    return [ECCollectionViewLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    [self registerClass:[ECCollectionReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:attributes];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        // Look for the first item in a row
        if (attribute.representedElementKind == UICollectionElementCategoryCell
            && attribute.frame.origin.x == self.sectionInset.left) {
            
            // Create decoration attributes
            ECCollectionViewLayoutAttributes *decorationAttributes =
            [ECCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier withIndexPath:attribute.indexPath];
            
            // Make the decoration view span the entire row (you can do item by item as well.  I just choose to do it this way)
            decorationAttributes.frame = CGRectMake(0, attribute.frame.origin.y - (self.sectionInset.top), self.collectionViewContentSize.width, self.itemSize.height + (self.minimumLineSpacing + self.sectionInset.top + self.sectionInset.bottom));
            
            // Set the zIndex to be behind the item
            decorationAttributes.zIndex = attribute.zIndex - 1;
            
            // Add the attribute to the list
            [allAttributes addObject:decorationAttributes];
        }
    }
    return allAttributes;
}

#pragma getter
- (id<LongPressCollectionViewDelegateFlowLayout>)delegate {
    return (id<LongPressCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
}

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kLXCollectionViewKeyPath]) {
        if (self.collectionView != nil) {
            [self setupCollectionView];
        } else {
            [self tearDownCollectionView];
        }
    }
}

@end

@implementation ECCollectionViewLayoutAttributes
+ (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath {
    ECCollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    layoutAttributes.color = [UIColor whiteColor];
    return layoutAttributes;
}

- (id)copyWithZone:(NSZone *)zone {
    ECCollectionViewLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.color = [self.color copyWithZone:zone];
    return newAttributes;
}

@end

@implementation ECCollectionReusableView
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    //设置背景颜色
    ECCollectionViewLayoutAttributes *ecLayoutAttributes = (ECCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = ecLayoutAttributes.color;
}

@end
