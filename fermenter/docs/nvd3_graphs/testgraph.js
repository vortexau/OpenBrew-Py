var app = angular.module('app', ['nvd3']);

app.service('dataService', function($http) {
    this.getData = function() {
        // $http() returns a $promise that we can add handlers with .then()
        return $http({
            method: 'GET',
            url: 'http://192.168.1.62:1469/sensors/fridgeone/',
        });
    };
});

app.controller('myCtrl', function($scope, dataService){
        $scope.options = {
            chart: {
                type: 'lineChart',
                height: 450,
                margin : {
                    top: 20,
                    right: 20,
                    bottom: 40,
                    left: 55
                },
                x: function(d){ return d.x; },
                y: function(d){ return d.y; },
                useInteractiveGuideline: true,
                dispatch: {
                    stateChange: function(e){ console.log("stateChange"); },
                    changeState: function(e){ console.log("changeState"); },
                    tooltipShow: function(e){ console.log("tooltipShow"); },
                    tooltipHide: function(e){ console.log("tooltipHide"); }
                },
                xAxis: {
                    axisLabel: 'Time (ms)'
                },
                yAxis: {
                    axisLabel: 'Temperature (c)',
                    tickFormat: function(d){
                        return d3.format('.02f')(d);
                    },
                    axisLabelDistance: -10
                },
                callback: function(chart){
                    console.log("!!! lineChart callback !!!");
                }
            },
            title: {
                enable: true,
                text: 'Fermenter One - Temp Chart'
            },
        };

        //$scope.data = sinAndCos();
        //console.log($http);
        //console.log(JSON.stringify($scope.data));

        //$scope.data = $http({ method: 'GET', url: 'http://192.168.1.62:1469/sensors/fridgeone/'}).then(function successCallback(response) {
        //    console.log(response.data);
        //    return response.data;
        //}, function failedCallback() { 
        //
        //});

        $scope.data = null;
        dataService.getData().then(function(dataResponse) {
            console.log(dataResponse);
            $scope.data = dataResponse.data;
        });

        console.log(JSON.stringify($scope.data));

        /*Random Data Generator */
        function sinAndCos() {
            var sin = [],sin2 = [],
                cos = [];

            //Data is represented as an array of {x,y} pairs.
            for (var i = 0; i < 100; i++) {
                sin.push({x: i, y: Math.sin(i/10)});
                sin2.push({x: i, y: i % 10 == 5 ? null : Math.sin(i/10) *0.25 + 0.5});
                cos.push({x: i, y: .5 * Math.cos(i/10+ 2) + Math.random() / 10});
            }

            //Line chart data should be sent as an array of series objects.
            return [
                {
                    values: sin,      //values - represents the array of {x,y} data points
                    key: 'Ambient', //key  - the name of the series.
                    color: '#ff7f0e'  //color - optional: choose your own line color.
                },
                {
                    values: cos,
                    key: 'Air',
                    color: '#2ca02c'
                },
                {
                    values: sin2,
                    key: 'Wort',
                    color: '#7777ff',
                }
            ];
        };
    })
