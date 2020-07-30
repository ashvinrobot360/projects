import matplotlib.pyplot as plt

slices = [7,2,2,15]
activities =['a', 'b', 'c', 'd']
cols = ['c', 'm', 'r', 'b']

plt.pie(slices,
        labels=activities,
        colors=cols,
        startangle=90,
        shadow=True,
        explode=(0,0.1,0,0),
        autopct='%1.1f%%')
plt.legend()
plt.title('Pie Chart')
plt.show()