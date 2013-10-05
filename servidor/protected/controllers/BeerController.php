<?php

class BeerController extends Controller
{
	/**
	 * @var string the default layout for the views. Defaults to '//layouts/column2', meaning
	 * using two-column layout. See 'protected/views/layouts/column2.php'.
	 */
	public $layout='//layouts/column2';

	/**
	 * @return array action filters
	 */
	public function filters()
	{
		return array(
			'accessControl', // perform access control for CRUD operations
			'postOnly + delete', // we only allow deletion via POST request
		);
	}

	/**
	 * Specifies the access control rules.
	 * This method is used by the 'accessControl' filter.
	 * @return array access control rules
	 */
	public function accessRules()
	{
		return array(
		   /* array('allow',  // allow all users to perform 'index' and 'view' actions
				'actions'=>array('index','view'),
				'users'=>array('*'),
			),
			array('allow', // allow authenticated user to perform 'create' and 'update' actions
				'actions'=>array('create','update'),
				'users'=>array('@'),
			),
			array('allow', // allow admin user to perform 'admin' and 'delete' actions
				'actions'=>array('admin','delete'),
				'users'=>array('admin'),
			),
			array('deny',  // deny all users
				'users'=>array('*'),
			), */
		);
	}

	/**
	 * Displays a particular model.
	 * @param integer $id the ID of the model to be displayed
	 */
	public function actionView($id)
	{
		$this->render('view',array(
			'model'=>$this->loadModel($id),
		));
	}

	/**
	 * Creates a new model.
	 * If creation is successful, the browser will be redirected to the 'view' page.
	 */
	public static function actionCreate($beer,$idLocation)
	{
		$model=new Beer;  
		
	   

		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if($beer)
		{
			$model->name = $beer->name;
			 
			$model->idType = $beer->idType;
			
			$model->locationid = $idLocation;
			
			if($model->save()){
			   	return $model; 
			}else {
				echo "aqui dedabjo de save beer";
			}  
				//$this->redirect(array('view','id'=>$model->id));
		}

		/*$this->render('create',array(
			'model'=>$model,
		));*/
	}

	/**
	 * Updates a particular model.
	 * If update is successful, the browser will be redirected to the 'view' page.
	 * @param integer $id the ID of the model to be updated
	 */
	public function actionUpdate($id)
	{
		$model=$this->loadModel($id);

		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if(isset($_POST['Beer']))
		{
			$model->attributes=$_POST['Beer'];
			if($model->save())
				$this->redirect(array('view','id'=>$model->id));
		}

		$this->render('update',array(
			'model'=>$model,
		));
	}

	/**
	 * Deletes a particular model.
	 * If deletion is successful, the browser will be redirected to the 'admin' page.
	 * @param integer $id the ID of the model to be deleted
	 */
	public function actionDelete($id)
	{
		$this->loadModel($id)->delete();

		// if AJAX request (triggered by deletion via admin grid view), we should not redirect the browser
		if(!isset($_GET['ajax']))
			$this->redirect(isset($_POST['returnUrl']) ? $_POST['returnUrl'] : array('admin'));
	}

	/**
	 * Lists all models.
	 */
	public function actionIndex()
	{
		$dataProvider=new CActiveDataProvider('Beer');
		$this->render('index',array(
			'dataProvider'=>$dataProvider,
		));
	}

	/**
	 * Manages all models.
	 */
	public function actionAdmin()
	{
		$model=new Beer('search');
		$model->unsetAttributes();  // clear any default values
		if(isset($_GET['Beer']))
			$model->attributes=$_GET['Beer'];

		$this->render('admin',array(
			'model'=>$model,
		));
	}

	/**
	 * Returns the data model based on the primary key given in the GET variable.
	 * If the data model is not found, an HTTP exception will be raised.
	 * @param integer $id the ID of the model to be loaded
	 * @return Beer the loaded model
	 * @throws CHttpException
	 */
	public function loadModel($id)
	{
		$model=Beer::model()->findByPk($id);
		if($model===null)
			throw new CHttpException(404,'The requested page does not exist.');
		return $model;
	}

	/**
	 * Performs the AJAX validation.
	 * @param Beer $model the model to be validated
	 */
	protected function performAjaxValidation($model)
	{
		if(isset($_POST['ajax']) && $_POST['ajax']==='beer-form')
		{
			echo CActiveForm::validate($model);
			Yii::app()->end();
		}
	}
	
	public function actionGetBeersByLocation()
	{   
		
		
			 $entityBody = file_get_contents('php://input');
			 $stdout = fopen('php://stdout', 'w');
			 $jsonLocation = json_decode( $entityBody );

			//the user data
			$city = $jsonLocation->city;
			$state = $jsonLocation->state;
			$country = $jsonLocation->country;
			     
			fwrite($stdout,$city.$state.$country."\n");
			                                    
		         /*
		
	  $city = str_replace('"',"",$city);   
	  $state = str_replace('"',"",$state);   
	  $country = str_replace('"',"",$country);  
	
	*/
	  $beers = Beer::model()->findAll();  
	  $cities = Location::model()->findByAttributes(array("name"=>$city,"sate"=>$state,"country"=>$country));
	  $beersLocal=Beer::model()->findAllByAttributes(array("locationid"=>$cities->id));
	
	   
	   
	
	    $data = array();
		
	    foreach ($beersLocal as $beer) {  
	    	array_push($data,array("id"=>($beer->id),"name"=>($beer->name),"type"=>($beer->type->name))); 
	    } 
	
	    	$this->sendData($data); 
	
	}  	
	
	public function actionGetPlacesByLocation()
	{       
		
		$entityBody = file_get_contents('php://input');
		 $stdout = fopen('php://stdout', 'w');
		 $jsonLocation = json_decode( $entityBody );

		//the user data
		$city = $jsonLocation->city;
		$state = $jsonLocation->state;
		$country = $jsonLocation->country;    
		
		/*
       $city = str_replace('"',"",$city);   
       $state = str_replace('"',"",$state);   
       $country = str_replace('"',"",$country);   
          */


	   	$cities = Location::model()->findAllByAttributes(array("name"=>$city,"sate"=>$state,"country"=>$country));
	   
		 $data = array();
	    
	   foreach ($cities as $city) {
	     foreach ($city->places as $place) {
	     	array_push($data,array("id"=>$place->id,"name"=>$place->latitude));
	     }   
		}
		
		$this->sendData($data); 
		
	}  
	
	
	
	public function actionGetBeersByLocationRanked()
	{
		 $entityBody = file_get_contents('php://input');
			 $stdout = fopen('php://stdout', 'w');
			 $jsonLocation = json_decode( $entityBody );
			fwrite($stdout,"resibiendo el cuerpo".$entityBody."\n");  

			//the user data
			$locationId = $jsonLocation->locationId;
			//$locationId = 9;
			/*           
			    $city = "Monterrey";
				$state = "NL";
				$country = "Mexico";
				
				*/
				
				fwrite($stdout,"resibiendo el json");  

		//$cities = Location::model()->findByAttributes(array("name"=>$city,"sate"=>$state,"country"=>$country));

		$sql = "SELECT idBeer, b.name, b.idType, AVG(r.stars) as average from beer b, rating r where b.id = r.idBeer AND b.locationId = " . $locationId. " group by b.name order by average desc;";
		fwrite($stdout,"despues de el sql".$locationId);  
        
		
		$beers= Yii::app()->db->createCommand($sql)->queryAll();  
		fwrite($stdout,"despues de ejecutar el query");  
		
		$data = array();
		foreach ($beers as $beer) {
		   array_push($data,array("idBeer"=>$beer["idBeer"],"name"=>$beer["name"],"idType"=>$beer["idType"],"average"=>$beer["average"]));
		} 
		
		$this->sendData($data);
	}
	
	
	
	public function sendData($data)
	{
	   	header('Cache-Control: no-cache, must-revalidate');
		header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
		header('Content-type: application/json');

		print_r(json_encode($data)); 
	}
	
	
	
	
	
	
}
