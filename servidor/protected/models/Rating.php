<?php

/**
 * This is the model class for table "rating".
 *
 * The followings are the available columns in table 'rating':
 * @property integer $id
 * @property integer $stars
 * @property integer $idBeer
 *
 * The followings are the available model relations:
 * @property Beer $idBeer0
 */
class Rating extends CActiveRecord
{
	/**
	 * Returns the static model of the specified AR class.
	 * @param string $className active record class name.
	 * @return Rating the static model class
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
		return 'rating';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('stars, idBeer', 'required'),
			array('stars, idBeer', 'numerical', 'integerOnly'=>true),
			// The following rule is used by search().
			// Please remove those attributes that should not be searched.
			array('id, stars, idBeer', 'safe', 'on'=>'search'),  
			
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
			'averageRating' => array(self::STAT, 'Beer', 'idBeer', 'select' => 'AVG(stars)'),  
			
			
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'stars' => 'Stars',
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
		$criteria->compare('stars',$this->stars);
		$criteria->compare('idBeer',$this->idBeer);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}
}