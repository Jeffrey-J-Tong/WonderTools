# Manual Sorting with Phy

## FeatureView

FeatureView computes and displays principle component features for the [best channel](https://phy.readthedocs.io/en/latest/sorting_user_guide/#best-channel) to aid the user in deciding whether events arise from the same or different clusters. The grid is arranged as follows:

![cluster features](https://raw.githubusercontent.com/kwikteam/phy-contrib/master/docs/screenshots/cluster_features.png)

There are four features you can see (channel0 pc0 and 1, channel1 pc0 and 1). Each of these is has its own row and column to give you all combinations. The main diagonal is special, with time always on the x-axis.

Channel0 can be selected or changed using `ctrl + left click` on WaveformView, Channel1 can be selected or changed using `ctrl + right click`.

## Manipulations

`Merging`: If you decide that multiple clusters are very likely to originate from the same cell, you should merge them into a single cluster by pressing the `G` key. This will merge all currently selected clusters. This will result in a new `cluster_id` and will remove the old ones.

`Splitting`: If the cluster has two clearly distinct groups of waveforms in the same channel then you should consider splitting the cluster into two groups. Try looking at the FeatureView. If you think the cluster may be made of two distinct groups encircle one of the groups by holding down `Ctrl` and `left click` around the group you would like to isolate. Each click creates a corner of a polygon selection. Once happy with the selection press `K`. Ideally this will successfully separate the two waveforms into two separate clusters. `Ctrl + right click` will undo your selection.

Assessing `stability`: stability can be inferred using the AmplitudeView and/or the first feature component that is displayed in the top left panel of the FeatureView. This component relates to the scaling of the templates, which should be fairly consistent over the whole recording time. If there is drift away from the neuron, then one would expect the waveforms to decrease.

Assessing `refractory period`: provided that `n_spikes` is large enough, and that events come from a single, well isolated cell, the ACG should be 0 at the centre of the x-axis corresponding to an extremely low or non existent correlation at lag 0). This is because of the refractory period of the neuron. If the cluster is made up of two distinct neurons, it is very likely that there will be no refractory period.

## Keyboard shortcuts

- Merging and splitting

  Merge: `G` Split: `K` Select for splitting: Hold `Ctrl` and use the `left mouse click` (on FeatureView) to define each point of your desired polygon. Define a region around the events you want to separate and press `K` to split when you are satisfied with your selection. `Ctrl + right mouse click` will undo your selection.

- Classifying clusters

  Classify selected cluster(s) as 'good': `Alt + G` Classify selected similar cluster(s) as 'good': `Ctrl + G`

  Classify selected cluster(s) as 'MUA': `Alt + M` Classify selected similar cluster(s) as 'MUA': `Ctrl + M`

  Classify selected cluster(s) as 'noise': `Alt + N` Classify selected similar cluster(s) as 'noise': `Ctrl + N`

- Moving, zooming, adjusting

  Drag: `Left mouse button` Zoom: `Right mouse button and drag` Increase scaling: `Alt + up` Decrease scaling: `Alt + down`

- Misc

  Undo: `Ctrl + Z` Select most similar/next most similar cluster: `spacebar`

