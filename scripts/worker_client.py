#!/usr/bin/env python3
import argparse,fcntl,os,socket,struct,subprocess,sys,time
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent
RUNTIME=Path(os.environ.get("XDG_RUNTIME_DIR",f"/tmp/neurabash-{os.getuid()}"))/"neurabash"
SOCK=RUNTIME/"daemon.sock"; LOCK=RUNTIME/"daemon.lock"; LOG=RUNTIME/"daemon.log"
def connect():
 s=socket.socket(socket.AF_UNIX,socket.SOCK_STREAM); s.connect(str(SOCK)); return s
def ensure_daemon():
 RUNTIME.mkdir(parents=True,exist_ok=True); os.chmod(RUNTIME,0o700)
 try: s=connect(); s.close(); return
 except OSError: pass
 with open(LOCK,"a+b") as lf:
  fcntl.flock(lf,fcntl.LOCK_EX)
  try: s=connect(); s.close(); return
  except OSError: pass
  try: SOCK.unlink()
  except FileNotFoundError: pass
  log=open(LOG,"ab",buffering=0)
  subprocess.Popen(["julia",f"--project={ROOT/'julia'}",str(ROOT/"julia/bin/daemon.jl"),"--socket",str(SOCK)],stdin=subprocess.DEVNULL,stdout=log,stderr=log,start_new_session=True,close_fds=True)
  deadline=time.time()+8
  while time.time()<deadline:
   try: s=connect(); s.close(); return
   except OSError: time.sleep(.05)
  detail=""
  try: detail=LOG.read_text(errors="replace")[-4000:]
  except Exception: pass
  raise RuntimeError(f"daemon did not start; see {LOG}\n{detail}")
def recv_exact(s,n):
 out=bytearray()
 while len(out)<n:
  b=s.recv(n-len(out))
  if not b: raise EOFError("daemon closed connection")
  out.extend(b)
 return bytes(out)
def main():
 ap=argparse.ArgumentParser(add_help=False); ap.add_argument("--root",action="store_true"); ap.add_argument("--source",required=True); a=ap.parse_args()
 ensure_daemon(); sid=os.environ.get("NEURABASH_SESSION_ID",f"ephemeral-{os.getppid()}").encode(); src=a.source.encode(); data=b"" if a.root else sys.stdin.buffer.read()
 s=connect(); s.sendall(b"NBP1"+struct.pack(">IIQQ",len(sid),1 if a.root else 0,len(src),len(data))+sid+src+data)
 if recv_exact(s,4)!=b"NBR1": raise RuntimeError("bad daemon response")
 status,outlen,errlen=struct.unpack(">IQQ",recv_exact(s,20)); out=recv_exact(s,outlen); err=recv_exact(s,errlen); s.close()
 sys.stdout.buffer.write(out); sys.stdout.buffer.flush(); sys.stderr.buffer.write(err); sys.stderr.buffer.flush(); return status
if __name__=="__main__":
 try: raise SystemExit(main())
 except Exception as e: print(f"DaemonError: {e}",file=sys.stderr); raise SystemExit(71)
