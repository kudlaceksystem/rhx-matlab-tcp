# Intan RHX TCP applet
This console app written in Matlab aims to be a simple interface
for the Intan RHX software by using its TCP server.

# Quick start guide
First, set up the TCP server within Intan RHX. Refer to the [Intan RHX documentation](https://intantech.com/files/Intan_RHX_user_guide.pdf), 
page 30, for more details on this. Once you have clicked **Connect** in the 
TCP server setup window and have noted the IP and port on which the server is running,
you can open `main.m` within this applet.

Here, you need to specify the IP address and port of the Intan RHX TCP server
to the instance of `RHXClient` initialized within `main()`. This can be done as follows:
```
client = RHXClient(ServerAddress="127.0.0.1", ServerPort=5000);
``` 

Do note that the IP `127.0.0.1` with port 5000 are default values, and thus do 
not have to be specified explicitly. Hence, the following is sufficient in case these values apply to your case:
```
client = RHXClient();
```

Once you have configured access to the TCP server within `main.m`, you are ready
to go to make use of the applet. Go ahead and press F5 while having `main.m`
open to start the applet. Type commands in the command window to communicate with
the TCP server.

## Disconnecting from the server and error handling

The Intan RHX app is made in such a way that when the client (ie., this applet) disconnects from the RHX TCP server,
the server automatically shuts down.

Therefore, if you want to **reconnect** to the Intan RHX TCP server, you must first click on `connect` within the Intan RHX app, 
then click `run` in Matlab while having `main.m` selected. 

In case an error occurs while executing a command you issued to the TCP server through this applet, one of two situations may arise:

1. the error will crash the applet, which will automatically disconnect it from the TCP server and the TCP server will close. You must first click `connect` in the Intan RHX app before re-running this applet.
2. the error will not crash the applet, but will be only printed on the screen (in white text - not in red!). You can continue to use the applet without having to restart the Intan TCP server, since the server itself didn't close.

## A general note on channel names

In various commands accessible through the applet, you will need to specify a channel name (for example, when configuring a stimulation).
For this, you will need the **native** channel name, for example, A-001. This seems to be a limitation of the Intan RHX API, as there isn't
any way to eg. configure stimulation parameters directly through a custom name assigned to a channel, nor is there a way to retrieve the 
native name of a channel by sending its custom name to the API. I will look into this problem in the future, but I am not sure there is much
I can do about it...

# Usage reference

## Stimulate using a pre-defined key
If the Intan RHX client already has a stimulation protocol pre-defined and bound to a keyboard key (F1 - F8),
stimulation can be triggered by sending the `Stim` command, followed by the desired key.

Example:
```
Stim F1
```

## Configure stimulation parameters
The stimulation protocol for a given channel can be configured using this command. 
Use the verb `Stim-Conf`, followed by a list of space-separated key-value pairs (case-sensitive!) such as
`Shape=Biphasic`. You must **always** include the `Channel` key (see below). The following parameters are supported:

- Shape - stimulation shape, either Biphasic or Triphasic (BiphasicWithInterphaseDelay isn't supported yet)
- Polarity - either NegativeFirst or PositiveFirst
- Source - see "Source" in the Intan RHX API docs, pg. 50.
- IsPulseTrain - boolean indicating if the stimulation is to be a single impulse or a pulse train. For impulse train, set the value to `True`. Otherwise use `False`.
- NumPulses - integer specifying the number of stimulation pulses if the protocol is set to be a pulse train.
- PulseTrainDurationUS - integer (microseconds) specifying how long each individual stimulation lasts in a pulse train before the next stimulation in the train begins
- DurationUS - integer (microseconds) specifying the total duration of the impulse. If the pulse is biphasic, each phase will be equal to half of the specified value.
- AmplitudeUA - integer (microamperes) specifying the current amplitude of each impulse. This sets both the positive and negative amplitude for biphasic impulses.
- AmplitudeV - integer (volts), sets the stimulation amplitude for analog out channels.

You must supply a Channel key as well, formatting the channel as reqiured by the Intan RHX API pg. 46 under "Stimulation/Recording Controller".
For example, `Channel=B-001`. You must use the *native* name of the channel - this is an intrinsic limitation of the API and seemingly cannot be circumvented
(the API provides no way of retrieving the native channel name given the user-defined channel name).

You can also set the stimulation for analog out channels. Simply prefix your channel name with `ANALOG-OUT-` (case-sensitive!), for example `Channel=ANALOG-OUT-1`.
When configuring analog out channels, use `AmplitudeV` instead of `AmplitudeUA`.

Example:
```
Stim-Conf Channel=A-001 Shape=Biphasic Source=KeyPressF1 IsPulseTrain=False DurationUS=500 AmplitudeUA=50
```

## Enable/disable the stimulation protocol for a given channel
You can toggle the enabled state of the stimulation protocol for a given channel by using the `Toggle-Stim` verb,
with the first positional parameter being the *native* channel name, and the second parameter either being `on` or `off`.

Note that this isn't the same thing as toggling the enabled/disabled state of the channel itself. Though I am not quite sure how the inernals
of Intan RHX work in this regard, it seems that you can have recording disabled, but stimulation enabled for a given channel. This command controls
only the stimulation on/off state for a given channel, not the recording state.

Example 1:
```
Toggle-Stim A-001 on
```

Example 2:
```
Toggle-Stim B-017 off
```