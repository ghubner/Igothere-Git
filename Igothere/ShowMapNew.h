//
//  ShowMapNew.h
//  InspectionView
//
//  Created by CRW on 3/29/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface ShowMapNew : NSObject<MKAnnotation> {
    
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
    NSString *inspectionID;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *inspectionID;
@end
