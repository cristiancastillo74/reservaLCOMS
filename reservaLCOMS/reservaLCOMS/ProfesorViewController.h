//
//  ProfesorViewController.h
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Profesor.h"


@interface ProfesorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *idProfesorField;
@property (strong, nonatomic) IBOutlet UITextField *nombreProfesorField;

@property (strong, nonatomic) IBOutlet UITableView *ProfesoresTableView;

- (IBAction)InsertarProfesorBoton:(id)sender;
- (IBAction)SeleccionarProfesorBoton:(id)sender;
- (IBAction)ActualizarProfesorBoton:(id)sender;
- (IBAction)EliminarProfesorBoton:(id)sender;

@end
