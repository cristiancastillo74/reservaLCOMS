//
//  ReservacionViewController.h
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Reservacion.h"

@interface ReservacionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *idReservacionField;
@property(strong,nonatomic) IBOutlet UITextField *idProfesorField;
@property(strong, nonatomic)IBOutlet UITextField *codigoAsignaturaField;
@property(strong, nonatomic)IBOutlet UITextField *codigoLaboratorioField;
@property(strong, nonatomic)IBOutlet UITextField *idHorarioField;
@property(strong, nonatomic)IBOutlet UITextField *idDiaField;

@property (strong, nonatomic) IBOutlet UITableView *ReservacionTableView;
-(IBAction)insertarReservacionBoton:(id)sender;
-(IBAction)consultarReservacionBoton:(id)sender;
-(IBAction)actualizarReservacionBoton:(id)sender;
-(IBAction)eliminarReservacionBoton:(id)sender;




@end
