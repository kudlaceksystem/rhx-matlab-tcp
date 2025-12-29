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

Refer to the documentation for this applet below (coming soon!) in case you 
need to modify or extend some of its functionalities.

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
Use the verb `Stim-Conf`, followed by a list of space-separated key-value pairs such as
`Shape=Biphasic`. The following parameters are supported:

- Shape - stimulation shape, either Biphasic or Triphasic (BiphasicWithInterphaseDelay isn't supported yet)
- Polarity - either NegativeFirst or PositiveFirst
- Source - see "Source" in the Intan RHX API docs, pg. 50.
- IsPulseTrain - boolean indicating if the stimulation is to be a single impulse or a pulse train. For impulse train, set the value to `True`. Otherwise use `False`.
- NumPulses - integer specifying the number of stimulation pulses if the protocol is set to be a pulse train.
- PulseTrainDurationUS - integer (microseconds) specifying how long each individual stimulation lasts in a pulse train before the next stimulation in the train begins
- DurationUS - integer (microseconds) specifying the total duration of the impulse. If the pulse is biphasic, each phase will be equal to half of the specified value.
- AmplitudeUA - integer (microamperes) specifying the current amplitude of each impulse. This sets both the positive and negative amplitude for biphasic impulses.

You must supply a Channel key as well, formatting the channel as reqiured by the Intan RHX API pg. 46 under "Stimulation/Recording Controller".
For example, `Channel=B-001`. You must use the *native* name of the channel.

Example:
```
Stim-Conf Channel=A-001 Shape=Biphasic Source=KeyPressF1 IsPulseTrain=False DurationUS=500 AmplitudeUA=50
```

## Enable/disable the stimulation protocol for a given channel
You can toggle the enabled state of the stimulation protocol for a given channel by using the `Toggle-Stim` verb,
with the first positional parameter being the *native* channel name, and the second parameter either being `on` or `off`.

Example 1:
```
Toggle-Stim A-001 on
```

Example 2:
```
Toggle-Stim B-017 off
```