//
//  MateriasViewController.h
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<sqlite3.h>

#import "Materias.h"

@interface MateriasViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *codAsignaturaField;
@property (strong, nonatomic) IBOutlet UITextField *nombreField;
@property (strong, nonatomic) IBOutlet UITextField *cicloField;
@property (strong, nonatomic) IBOutlet UITableView *asignaturaTableView;
- (IBAction)insertarAsignatura:(id)sender;
- (IBAction)consultarAsignatura:(id)sender;
- (IBAction)actualizarAsignatura:(id)sender;

- (IBAction)eliminarAsignatura:(id)sender;



@end
