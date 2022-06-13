<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <script type="text/javascript" src="../../../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="../../../jquery/echars/echarts.min.js"></script>
    <title>echarts</title>
    <script type="text/javascript">
        $(function (){

            $.ajax({
                url:'http://localhost:8111/crm/workbench/chart/transactinn/queryCountOfTranGroupByStage.do',
                type:'post',
                datatype:'json',
                success:function (data){
                    //调用echarts工具函数
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));//提交容器对象

                    // 指定图表的配置项和数据


                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption( option = {
                        title: {
                            text: 'Funnel'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b} : {c}%'
                        },
                        toolbox: {
                            feature: {
                                dataView: { readOnly: false },
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
                        },
                        series: [
                            {
                                name: 'Funnel',
                                type: 'funnel',
                                left: '10%',
                                top: 60,
                                bottom: 60,
                                width: '80%',
                                min: 0,
                                max: 100,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: data
                            }
                        ]
                    });
                    myChart.setOption(option);
                }
            })

        })
    </script>
</head>
<body>
<body>
<!-- 为 ECharts 准备一个定义了宽高的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>
</body>
</body>
</html>