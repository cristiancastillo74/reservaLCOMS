//
//  Reservacion.m
//  reservaLCOMS
//
//  Created by Melissa  Melendez on 5/21/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reservacion : NSObject



@property (assign) int numReservacion;
@property (nonatomic, strong)NSString *idReservacion;
@property (nonatomic, strong)NSString *idProfesor;
@property (nonatomic, strong)NSString *codAsignatura;
@property (nonatomic, strong)NSString *conLab;
@property (nonatomic, strong)NSString *idHorario;
@property (nonatomic, strong)NSString *idDia;

@end
