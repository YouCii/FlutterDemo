/// 工厂方法 + 重写构造方法
class FactoryBean {

  FactoryBean.createInstance();

  FactoryBean._();

  factory FactoryBean(var data){
    return FactoryBean._();
  }

}