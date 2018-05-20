//
//  controlBD.h
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface controlBD : NSObject

@property (strong,nonatomic) NSString *dbPath;
+(controlBD *) sharedInstance;
-(void) crearOabrirBD;
@end
