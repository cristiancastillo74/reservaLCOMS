//
//  TipolabViewController.h
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "TipoLab.h"

@interface TipolabViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *idTipoLabField;
@property (strong, nonatomic) IBOutlet UITextField *nombreField;
@property (strong, nonatomic) IBOutlet UITextField *ramField;
@property (strong, nonatomic) IBOutlet UITextField *sistemasOpeField;
@property (strong, nonatomic) IBOutlet UITextField *capacidadDiscoField;
@property (strong, nonatomic) IBOutlet UITextField *procesadorField;
@property (strong, nonatomic) IBOutlet UITableView *TipolabTableView;

- (IBAction)InsertarTipolabBoton:(id)sender;
- (IBAction)ActualizarTipolabBoton:(id)sender;
- (IBAction)SeleccionarTipolabBoton:(id)sender;
- (IBAction)EliminarTipolabBoton:(id)sender;


@end
