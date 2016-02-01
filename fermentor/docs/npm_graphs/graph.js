/* globals angular */
(function() {
    angular.module('google-chart-sample', ['googlechart', 'googlechart-docs'])
        .controller('HideSeriesController', HideSeriesController);

    HideSeriesController.$inject = ['$scope'];

    function HideSeriesController($scope) {
        // Properties
        $scope.chartObject = {};

        //Methods
        $scope.hideSeries = hideSeries;
        
        init();

        function hideSeries(selectedItem) {
            var col = selectedItem.column;
            if (selectedItem.row === null) {
                if ($scope.chartObject.view.columns[col] == col) {
                    $scope.chartObject.view.columns[col] = {
                        label: $scope.chartObject.data.cols[col].label,
                        type: $scope.chartObject.data.cols[col].type,
                        calc: function() {
                            return null;
                        }
                    };
                    $scope.chartObject.options.colors[col - 1] = '#CCCCCC';
                }
                else {
                    $scope.chartObject.view.columns[col] = col;
                    $scope.chartObject.options.colors[col - 1] = $scope.chartObject.options.defaultColors[col - 1];
                }
            }
        }

        function init() {
            $scope.chartObject.type = "LineChart";
            $scope.chartObject.displayed = false;

            $scope.chartObject.data = {
                "cols": [{ 
                    id: "time",
                    label: "Minute",
                    type: "string"
                }, { 
                    id: "ambient-id",
                    label: "Ambient",
                    type: "string"
		}],
                "rows": [{ 
                    c: [{ 
		        v: "10"
                    }, {
                        v: "12",
                        f: "12 degrees"
	            }]
                }]
            };

            $scope.chartObject.options = {
                "title": "Sales per month",
                "colors": ['#0000FF', '#009900', '#CC0000', '#DD9900'],
                "defaultColors": ['#0000FF', '#009900', '#CC0000', '#DD9900'],
                "isStacked": "true",
                "fill": 20,
                "displayExactValues": true,
                "vAxis": {
                    "title": "Sales unit",
                    "gridlines": {
                        "count": 10
                    }
                },
                "hAxis": {
                    "title": "Date"
                }
            };

            $scope.chartObject.view = {
                columns: [0, 1, 2, 3, 4]
            };

            console.log($scope.chartObject);

        }
    }
})();
