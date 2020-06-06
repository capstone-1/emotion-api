from collections import OrderedDict
def convert_to_sec(time_str) :
    hour, minute, sec = time_str.split(":")
    return int(sec) + (int(minute)*60) + (int(hour)*3600)

def extract_edit_point(source_file_name) :
    f = open("input/" + source_file_name+".txt")
    inter_result = []
    start = -1 
    lines = f.readlines()
    for line in lines :
        time, emotion, percentage = line.split(" ")
        if(emotion == "happy" and float(percentage.split("%")[0]) > 90) :
            inter_result.append(time)
    f.close()
    count = 0
    output = []
    for i, time in enumerate(inter_result) :
        timeValue = convert_to_sec(time)
        if (start == -1) :
            start = timeValue
        previous = convert_to_sec(inter_result[i-1].split(" ")[0])
        if (timeValue - previous) > 20 :
            end = previous
            if count > 5 :
                output.append(str(start) + " " + str(end))
            start = timeValue
            count = 0
        else :
            count = count + 1

    result_json = []
    for point in output:
        start = int(point.split(" ")[0])
        end = int(point.split(" ")[1])
        emotion_interval = OrderedDict()
        emotion_interval['start'] = start
        emotion_interval['end'] = end
        result_json.append(emotion_interval)
    response = OrderedDict()
    response["emotion_edit_point"] = result_json
    return response
