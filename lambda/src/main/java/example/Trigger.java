package example;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Trigger {

    @SerializedName("MetricName") private String metricName;
    @SerializedName("Statistic") private String statistic;
    @SerializedName("Unit") private String unit;
    @SerializedName("Dimensions") private List<Dimension> dimensions;
    @SerializedName("Period") private String period;
    @SerializedName("EvaluationPeriods") private int evaluationPeriods;
    @SerializedName("ComparisonOperator") private String comparisonOperator;
    @SerializedName("Threshold") private float threshold;

    public String getInstanceId() {
        for (int i = 0; i < dimensions.size(); i++) {
            Dimension dimension = dimensions.get(i);
            if (dimension.getName().equals("InstanceId")) {
                return dimension.getValue();
            }
        }
        return "";
    }

    public String getMetricName() {
        return metricName;
    }

    public float getThreshold() {
        return threshold;
    }

    public String getComparisonOperator() {
        return comparisonOperator;
    }

    public String getUnit() {
        return unit;
    }

    static class Dimension {
        private String name;
        private String value;

        public String getName() {
            return name;
        }

        public String getValue() {
            return value;
        }
    }
}
