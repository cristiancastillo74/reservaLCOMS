//
//  MateriasViewController.m
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import "MateriasViewController.h"
#import "controlBD.h"


@interface MateriasViewController (){
    NSMutableArray *arrayMaterias;
    sqlite3 *reservaBD;
    NSString *dbPathSting;
}
@end

@implementation MateriasViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [[controlBD sharedInstance] crearOabrirBD];
    arrayMaterias=[[NSMutableArray alloc]init];
    [[self asignaturaTableView]setDelegate:self];
    [[self asignaturaTableView]setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayMaterias count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    Materias *mMaterias=[arrayMaterias objectAtIndex:indexPath.row];
    cell.textLabel.text=mMaterias.codAsignatura;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",mMaterias.nombre,mMaterias.ciclo];
    
    return cell ;
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)insertarAsignatura:(id)sender {
    char *error;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO asignatura(codAsignatura,nombre,ciclo) values ('$s','$s','$s')",[self.codAsignaturaField.text UTF8String],[self.nombreField.text UTF8String],[self.cicloField.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        if(sqlite3_exec(reservaBD, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            NSLog (@"Materia Insertada correctamente");
            
            Materias *materias =[[Materias alloc]init];
            [materias setCodAsignatura:self.codAsignaturaField.text];
            [materias setNombre:self.nombreField.text];
            [materias setCiclo:self.cicloField.text];
            [arrayMaterias addObject:materias];
        }
        else {
            NSLog(@" Registro no insertado");
        }
        sqlite3_close(reservaBD);
        
    }
}




- (IBAction)consultarAsignatura:(id)sender {
    sqlite3_stmt *statement;
    
    if(sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        [arrayMaterias removeAllObjects];
        NSString *querySql=[NSString stringWithFormat:@"SELECT * FROM asignatura"];
        const char *querysql=[querySql UTF8String];
        if(sqlite3_prepare(reservaBD, querysql, -1, &statement, NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *codAsignatura1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)];
                NSString *nombre1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,1)];
                NSString *ciclo1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,2)];
                
                Materias *materias =[[Materias alloc]init];
                [materias setCodAsignatura:codAsignatura1];
                [materias setNombre:nombre1];
                [materias setCiclo:ciclo1];
                
                [arrayMaterias addObject:materias];
                
                
                
            }
        }
        else{
            NSLog(@"Lista vacia");
        }
        sqlite3_close(reservaBD);
        
    }
    [[self asignaturaTableView]reloadData];
    
    
    
}

- (IBAction)actualizarAsignatura:(id)sender {
    
    static sqlite3_stmt *statement=nil;
     if(sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        
        char *update_Stmt="UPDATE asignatura SET nombre=?, ciclo=? WHERE codAsignatura=?";
        if(sqlite3_prepare_v2(reservaBD, update_Stmt, -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement, 1,[self.codAsignaturaField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2,[self.nombreField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3,[self.cicloField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            
            Materias *materias =[[Materias alloc]init];
            [materias setCodAsignatura:self.codAsignaturaField.text];
            [materias setNombre:self.nombreField.text ];
            [materias setCiclo:self.cicloField.text];
            
            [arrayMaterias addObject: materias];
            NSLog(@"Asignatura modificada");
            
            
            
        }
        else
        {
            NSLog(@"Asignatura no modificado");
        }
        sqlite3_close(reservaBD);
    }
}
    
    

- (IBAction)eliminarAsignatura:(id)sender {
      [[self asignaturaTableView]setEditing:!self.asignaturaTableView.editing animated:YES];
    
}

-(void)deleteData:(NSString *)deleteQuery
{
    char * error;
    if(sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        
        if(sqlite3_exec(reservaBD, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
            NSLog(@" Asignatura Eliminada");
            
        }
        else{
            NSLog(@"Asignatura No Eliminada");
        }
        sqlite3_close(reservaBD);
    }
       }
       
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: NSIndexPath *)indexPath{
           if(editingStyle==UITableViewCellEditingStyleDelete){
               Materias *reser =[arrayMaterias objectAtIndex:indexPath.row];
               [self deleteData:[NSString stringWithFormat:@"DELETE FROM RESERVACION WHERE IDRESERVACION ID '%s'",[reser.idReservacion UTF8String]]];
               [arrayReservacion removeObjectAtIndex: indexPath.row];
               [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
           }
           
       }
       
       
       -(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
           [super touchesBegan: touches withEvent:event];
           [[self idReservacionField] reseignFirstResponder];
           [[self idProfesorField] reseignFirstResponder];
           [[self idReservacionField] reseignFirstResponder];
           [[self idReservacionField] reseignFirstResponder];
           [[self idReservacionField] reseignFirstResponder];
           
           
       }
       



@end


