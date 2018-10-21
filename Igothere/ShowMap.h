//
//  ShowMap.h
//  InspectionView
//
//  Created by Gilberto Hubner on 1/19/12.
//  Copyright (c) 2012 CRW Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface ShowMap : NSObject <MKAnnotation> {
    
	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
    NSString *inspectionID;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@end

