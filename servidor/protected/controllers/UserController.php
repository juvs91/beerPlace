<?php

class UserController extends Controller
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
			/*array('allow',  // allow all users to perform 'index' and 'view' actions
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
			),*/
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
	public function actionCreate()
	{
		$model=new User;

		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if(isset($_POST['User']))
		{
			$model->attributes=$_POST['User'];
			if($model->save())
				$this->redirect(array('view','id'=>$model->id));
		}

		$this->render('create',array(
			'model'=>$model,
		));
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

		if(isset($_POST['User']))
		{
			$model->attributes=$_POST['User'];
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
		$dataProvider=new CActiveDataProvider('User');
		$this->render('index',array(
			'dataProvider'=>$dataProvider,
		));
	}

	/**
	 * Manages all models.
	 */
	public function actionAdmin()
	{
		$model=new User('search');
		$model->unsetAttributes();  // clear any default values
		if(isset($_GET['User']))
			$model->attributes=$_GET['User'];

		$this->render('admin',array(
			'model'=>$model,
		));
	}

	/**
	 * Returns the data model based on the primary key given in the GET variable.
	 * If the data model is not found, an HTTP exception will be raised.
	 * @param integer $id the ID of the model to be loaded
	 * @return User the loaded model
	 * @throws CHttpException
	 */
	public function loadModel($id)
	{
		$model=User::model()->findByPk($id);
		if($model===null)
			throw new CHttpException(404,'The requested page does not exist.');
		return $model;
	}

	/**
	 * Performs the AJAX validation.
	 * @param User $model the model to be validated
	 */
	protected function performAjaxValidation($model)
	{
		if(isset($_POST['ajax']) && $_POST['ajax']==='user-form')
		{
			echo CActiveForm::validate($model);
			Yii::app()->end();
		}
	}  
	//login from users through facebook
	public function actionLogin($id)
	{   
		   $user = new User;

		   $user = User::model()->findByPk($id);
            
		   
			
			if (!$user) {
				$user = new User;
				$user->id = $id; 
				if(!($user->save())){
				  echo(json_encode("error"));   
				}
			  }  
			  $this->sendData(array("id"=>$user->id,"contributed"=>$user->contributed));
		
		
		
	}
	
	//sign up adding the contributed
	public function actionRating()
	{
		 //$_POST['BeerRating'] = array("User"=>array("id"=>1,"contributed"=>1),"Beer"=>array("name"=>"xxlager","idType"=>1),"Rating"=>array("stars"=>5),"Location"=>array("city"=>"monterrey","state"=>"nuevo leon","country"=>"mexico"),"Place"=>array("name"=>"Sierra madre"));
		  
		 $entityBody = file_get_contents('php://input');
		 $stdout = fopen('php://stdout', 'w');
		 $jsonBeerRating = json_decode( $entityBody );
		
		//the user data
		$userJson = $jsonBeerRating->User;
		//the Beer data
		$beerJson = $jsonBeerRating->Beer;
		//the Rating data
		$ratingJson = $jsonBeerRating->Rating;
		//the Location data
		$locationJson = $jsonBeerRating->Location;
		//the place data
		$placeJson = $jsonBeerRating->Place; 
		

		
		   
				
		
		//pass the atributes of the user
		 
		$user = User::model()->findByPk($userJson->id);  
		//pass the atributes of the location

		//get the id of the location
		//$controller = new LocationController;   
		Yii::import('application.controllers.LocationController');
		$idLocation = LocationController::getLocation($locationJson);
         fwrite($stdout,"anted de los json idLocation".$idLocation->id);  

	   
		//pass the atributes of the beer  
		 
		//create the beer 
		Yii::import('application.controllers.BeerController');
		$beer = BeerController::actionCreate($beerJson,$idLocation->id);
        fwrite($stdout,"anted de los json idLocation".$idLocation->id);  

		//create the place  
		Yii::import('application.controllers.PlaceController');
		$place = PlaceController::actionCreate($placeJson,$idLocation->id,$beer->id);  
        fwrite($stdout,"anted de los json idLocation".$place->id);  

		//create the Rating  
		Yii::import('application.controllers.RatingController');
		$rating = RatingController::actionCreate($ratingJson,$beer->id);
        fwrite($stdout,"anted de los json idLocation".$rating->id);  
		
		$user->contributed = 1;
		
		if(!($user->update(array('contributed')))){
			echo "error en la base de datos";
		}   
		
		
		
	}   
	
	/*
		funcion envia el mensaje al cliente , solo le da el formato a json y le coloca los headers que es un arch json 
	*/
	public function sendData($data)
	{
	   	header('Cache-Control: no-cache, must-revalidate');
		header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
		header('Content-type: application/json');

		print_r(json_encode($data)); 
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
