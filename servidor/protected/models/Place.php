<?php

/**
 * This is the model class for table "Place".
 *
 * The followings are the available columns in table 'Place':
 * @property integer $id
 * @property integer $idLocation
 * @property string $latitude
 * @property integer $idBeer
 *
 * The followings are the available model relations:
 * @property Beer $idBeer0
 * @property Location $idLocation0
 */
class Place extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @param string $className active record class name.
	 * @return Place the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}

	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'Place';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('idLocation, idBeer', 'required'),
			array('idLocation, idBeer', 'numerical', 'integerOnly'=>true),
			array('latitude', 'length', 'max'=>1024),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, idLocation, latitude, idBeer', 'safe', 'on'=>'search'),
		);
	}

	/**
	 * @return array relational rules.
	 */
	public function relations()
	{
		// NOTE: you may need to adjust the relation name and the related
		// class name for the relations automatically generated below.
		return array(
			'idBeer0' => array(self::BELONGS_TO, 'Beer', 'idBeer'),
			'idLocation0' => array(self::BELONGS_TO, 'Location', 'idLocation'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'idLocation' => 'Id Location',
			'latitude' => 'Latitude',
			'idBeer' => 'Id Beer',
		);
	}

	/**
	 * Retrieves a list of models based on the current search/filter conditions.
	 * @return CActiveDataProvider the data provider that can return the models based on the search/filter conditions.
	 */
	public function search()
	{
		// Warning: Please modify the following code to remove attributes that
		// should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id);
		$criteria->compare('idLocation',$this->idLocation);
		$criteria->compare('latitude',$this->latitude,true);
		$criteria->compare('idBeer',$this->idBeer);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}