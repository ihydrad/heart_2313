#include <io.h>
#include <stdio.h>
#include <delay.h>

#define sbi(BYTE, BITE)     BYTE|=(1<<BITE)
#define cbi(BYTE, BITE)     BYTE&=~(1<<BITE)

#define LED_BYTE            PORTB
#define RIGHT_UP            PORTA.0
#define LEFT_D              PORTA.1
#define LEFT_UP             PORTD.2
#define RIGHT_D             PORTD.3

#define ALL_ON              PORTB=0xFF
#define ALL_OFF             PORTB=0x00
#define RST_T0              TCNT0=0;
#define RST_T1              TCNT1H=0;TCNT1L=0;

#define PUT_DOWN            sbi(DDRD, 4);cbi(PORTD, 4)
#define SET_INPUT           cbi(DDRD, 4);cbi(PORTD, 4)
#define SENSOR              PIND.4

#define MUSIC               PORTD.6

#define TIME_NOTUCH         1

#define LINE_FLAG           0
#define ONE_LED_FLAG        1
#define FULL_FLAG           2
#define LAST_FLAG           3
#define MIG_FLAG            4

#define STOP_FLAG           5

#define TUCH_FLAG           6

flash char rst[]="booting...\r";

unsigned int sens_t, time;

char cnt, inv, up, flag;

void initdev()
{
 DDRA=0xFF;
 DDRB=0xFF;
 DDRD=0xEF;

 TCCR0B=0x02;
 OCR0A=5;

 TCCR1B=0x05;
 OCR1AH=0x01;
 OCR1AL=0x86;

 TIMSK=0x41;

 UCSRA=0x00;
 UCSRB=0x08;
 UCSRC=0x06;
 UBRRH=0x00;
 UBRRL=0x33;

 ACSR=0x80;
}

void line()
{
 up = ~up;

 if(!inv)
   {
    if(up)
     {
      ALL_OFF;
      LEFT_UP=1;
      RIGHT_UP=1;

      LEFT_D=0;
      RIGHT_D=0;

      if(cnt<7) ALL_OFF;
      else LED_BYTE|= ~(0xFF << (cnt - 7));
        }

     else
     {
      LEFT_UP=0;
      RIGHT_UP=0;

      LEFT_D=1;
      RIGHT_D=1;

      if(cnt>7) ALL_ON;
      else LED_BYTE|=~(0xFF<<cnt);
        }
     if(cnt==17)
       {
        cnt=0;
        inv=1;
         }
         }

   else
     {
       if(up)
         {
          ALL_OFF;
          LEFT_UP=1;
          RIGHT_UP=1;

          LEFT_D=0;
          RIGHT_D=0;

          if(cnt > 7) ALL_ON;
          else LED_BYTE|= ~(0xFF >> (cnt));
            }

         else
         {
          ALL_OFF;
          LEFT_UP=0;
          RIGHT_UP=0;

          LEFT_D=1;
          RIGHT_D=1;

          if(cnt < 7) ALL_OFF;
          else LED_BYTE|=~(0xFF >> (cnt - 7));
             }
      if(cnt==16)
        {
         cnt=0;
         inv=0;
         sbi(flag, ONE_LED_FLAG);
         cbi(flag, LINE_FLAG);
           }
             }

}

void one_led()
{
  if(!inv)
    {
     if(cnt > 23)
       {
        ALL_OFF;
        RIGHT_UP=0;
        RIGHT_D=0;
        LEFT_D=0;
        LEFT_UP=1;

        LED_BYTE|= (0x01 << (cnt - 24));

        if(LED_BYTE == 0)
          {
           cnt=0;
           inv=1;
            }
        goto exit;
          }

      if(cnt > 15)
       {
        ALL_OFF;
        RIGHT_UP=0;
        RIGHT_D=0;
        LEFT_D=1;
        LEFT_UP=0;

        LED_BYTE|= (0x01 << (cnt - 16));
        goto exit;
          }

      if(cnt > 7)
       {
        ALL_OFF;
        RIGHT_UP=0;
        RIGHT_D=1;
        LEFT_D=0;
        LEFT_UP=0;

        LED_BYTE|= (0x80 >> (cnt - 8));
        goto exit;
          }

      if(cnt < 7)
       {
        ALL_OFF;
        RIGHT_UP=1;
        RIGHT_D=0;
        LEFT_D=0;
        LEFT_UP=0;

        LED_BYTE|= (0x80 >> cnt);
        goto exit;
          }
          }

    else
    {
      if(cnt > 23)
       {
        ALL_OFF;
        RIGHT_UP=1;
        RIGHT_D=0;
        LEFT_D=0;
        LEFT_UP=0;

        LED_BYTE|= (0x01 << (cnt - 24));

        if(LED_BYTE == 0)
          {
           cnt=0;
           inv=0;
           cbi(flag, ONE_LED_FLAG);
           sbi(flag, FULL_FLAG);
            }
        goto exit;
          }

      if(cnt > 15)
       {
        ALL_OFF;
        RIGHT_UP=0;
        RIGHT_D=1;
        LEFT_D=0;
        LEFT_UP=0;

        LED_BYTE|= (0x01 << (cnt - 16));
        goto exit;
          }

      if(cnt > 7)
       {
        ALL_OFF;
        RIGHT_UP=0;
        RIGHT_D=0;
        LEFT_D=1;
        LEFT_UP=0;

        LED_BYTE|= (0x80 >> (cnt - 8));
        goto exit;
          }

      if(cnt < 7)
       {
        ALL_OFF;
        RIGHT_UP=0;
        RIGHT_D=0;
        LEFT_D=0;
        LEFT_UP=1;

        LED_BYTE|= (0x80 >> cnt);
        goto exit;
          }

      }

exit:
     }

void full()
{
 static char j;

 j++;
 if(j > 4) j=1;

 if(!inv)
   {
    switch (j)
       {
        case 1:
              ALL_OFF;
              RIGHT_UP=1;
              RIGHT_D=0;
              LEFT_D=0;
              LEFT_UP=0;
        break;

        case 2:
               ALL_OFF;
               RIGHT_UP=0;
               RIGHT_D=1;
               LEFT_D=0;
               LEFT_UP=0;
        break;

        case 3:
               ALL_OFF;
               RIGHT_UP=0;
               RIGHT_D=0;
               LEFT_D=1;
               LEFT_UP=0;
        break;

        case 4:
               ALL_OFF;
               RIGHT_UP=0;
               RIGHT_D=0;
               LEFT_D=0;
               LEFT_UP=1;
        break;

        default:break;
         }

    if(cnt > 23)
     {
      switch (j)
           {
            case 1:
                   ALL_ON;
            break;

            case 2:
                   ALL_ON;
            break;

            case 3:
                   ALL_ON;
            break;

            case 4:
                   LED_BYTE|= ~(0xFF << (cnt - 24));
                   if(LED_BYTE == 0xFF)
                     {
                      inv=1;
                      cnt=0;
                       }
            break;

            default:break;
                }

      goto exit1;
      }

    if(cnt > 15)
     {
       switch (j)
           {
            case 1:
                   ALL_ON;
            break;

            case 2:
                   ALL_ON;
            break;

            case 3:
                   LED_BYTE|= ~(0xFF << (cnt - 16));
            break;

            case 4:
                   ALL_OFF;
            break;

            default:break;
                }

      goto exit1;
      }

     if(cnt > 7)
     {
      switch (j)
           {
            case 1:
                   ALL_ON;
            break;

            case 2:
                   LED_BYTE|= ~(0xFF >> (cnt - 8));
            break;

            case 3:
                   ALL_OFF;
            break;

            case 4:
                   ALL_OFF;
            break;

            default:break;
                }

      goto exit1;
      }

   if(cnt < 7)
    {
     switch (j)
           {
            case 1:
                   LED_BYTE|= ~(0xFF >> cnt);
            break;

            case 2:
                   ALL_OFF;
            break;

            case 3:
                   ALL_OFF;
            break;

            case 4:
                   ALL_OFF;
            break;

            default:break;
                }

     goto exit1;
      }
      }

//**********************************************
   else
   {
    switch (j)
       {
        case 1:
              ALL_OFF;
              RIGHT_UP=0;
              RIGHT_D=0;
              LEFT_D=0;
              LEFT_UP=1;
        break;

        case 2:
               ALL_OFF;
               RIGHT_UP=0;
               RIGHT_D=0;
               LEFT_D=1;
               LEFT_UP=0;
        break;

        case 3:
               ALL_OFF;
               RIGHT_UP=0;
               RIGHT_D=1;
               LEFT_D=0;
               LEFT_UP=0;
        break;

        case 4:
               ALL_OFF;
               RIGHT_UP=1;
               RIGHT_D=0;
               LEFT_D=0;
               LEFT_UP=0;
        break;

        default:break;
         }

    if(cnt > 23)
     {
      switch (j)
           {
            case 1:
                   ALL_ON;
            break;

            case 2:
                   ALL_ON;
            break;

            case 3:
                   ALL_ON;
            break;

            case 4:
                   LED_BYTE|= ~(0xFF << (cnt - 24));
                   if(LED_BYTE == 0xFF)
                     {
                      inv=0;
                      cnt=0;
                      cbi(flag, FULL_FLAG);
                      sbi(flag, LAST_FLAG);
                      ALL_OFF;
                      time=0;
                       }
            break;

            default:break;
                }

      goto exit1;
      }

    if(cnt > 15)
     {
       switch (j)
           {
            case 1:
                   ALL_ON;
            break;

            case 2:
                   ALL_ON;
            break;

            case 3:
                   LED_BYTE|= ~(0xFF << (cnt - 16));
            break;

            case 4:
                   ALL_OFF;
            break;

            default:break;
                }

      goto exit1;
      }

     if(cnt > 7)
     {
      switch (j)
           {
            case 1:
                   ALL_ON;
            break;

            case 2:
                   LED_BYTE|= ~(0xFF >> (cnt - 8));
            break;

            case 3:
                   ALL_OFF;
            break;

            case 4:
                   ALL_OFF;
            break;

            default:break;
                }

      goto exit1;
      }

   if(cnt < 7)
    {
     switch (j)
           {
            case 1:
                   LED_BYTE|= ~(0xFF >> cnt);
            break;

            case 2:
                   ALL_OFF;
            break;

            case 3:
                   ALL_OFF;
            break;

            case 4:
                   ALL_OFF;
            break;

            default:break;
                }

     goto exit1;
      }
   }

   exit1:
  }

void last()
{
 static char state;

 up= ~up;

 if(up)
   {
    ALL_OFF;
    RIGHT_UP=1;
    LEFT_UP=1;

    RIGHT_D=0;
    LEFT_D=0;

    if(cnt < 8)
      {
       LED_BYTE|= (0x80 >> cnt);
        }

     }

 else
   {
    ALL_OFF;
    RIGHT_UP=0;
    LEFT_UP=0;

    RIGHT_D=1;
    LEFT_D=1;

    if(cnt >= 8)
      {
       LED_BYTE|= (0x80 >> cnt - 8);
        }

     }

   if(state && !up)
     {
      LED_BYTE|= ~(0xFF << state);
        }

   if(state > 8 && up)
     {
      LED_BYTE|= ~(0xFF << state - 8);
        }

 if(cnt == 15 - state)
  {
   state++;
   cnt= 0;

    if(state == 16)
     {
      state=0;
      time=0;
      sens_t=0;
      putchar('W');
      cbi(flag, LAST_FLAG);
      cbi(flag, TUCH_FLAG);
      sbi(flag, MIG_FLAG);
      RIGHT_UP=0;
      LEFT_UP=0;

      RIGHT_D=0;
      LEFT_D=0;
      cnt=0;
      up=0;
       }
       }
       }

void mig()
{
 static char val;

 RIGHT_UP=1;
 LEFT_UP=1;

 RIGHT_D=1;
 LEFT_D=1;
 ALL_ON;

 if(cnt < 25) ALL_ON;
 if(cnt > 25) ALL_OFF;

 if(cnt == 50)
   {
    cnt=0;
    val++;

     if(val == 7)
     {
      cbi(flag, MIG_FLAG);
      cbi(flag, TUCH_FLAG);

      RIGHT_UP=0;
      LEFT_UP=0;

      RIGHT_D=0;
      LEFT_D=0;
      ALL_OFF;
      MUSIC=0;
      val=0;
      time=0;
      sens_t=0;
      inv=0;
      up=0;
      flag=0;
      cnt=0;
      }
      }
      }

void sensor_drv()
{
  if(SENSOR)
         {
          sens_t = time;
          PUT_DOWN;
          //putchar(sens_t+48);
           if(sens_t > TIME_NOTUCH)
             {
              sbi(flag, TUCH_FLAG);
              putchar(sens_t+48);
               }
          sens_t=0;
          time=0;
          SET_INPUT;
           }
        }

void WD()
{
 #asm("cli")
 #asm("wdr")
 WDTCSR |= (1<<WDCE) | (1<<WDE);
 WDTCSR = (1<<WDE) | (1<<WDP2) | (1<<WDP0);
 #asm("sei")
}

void main()
{
 initdev();
 WD();
 PUT_DOWN;
 delay_us(500);
 SET_INPUT;
 #asm("sei")

 putsf(rst);

  while (1)
      {
       #asm("wdr")
       if( (flag & (1<<TUCH_FLAG)) && !(flag & (1<<LINE_FLAG)) && !(flag & (1<<ONE_LED_FLAG))
       && !(flag & (1<<FULL_FLAG)) && !(flag & (1<<LAST_FLAG)) && !(flag & (1<<MIG_FLAG)) )
         {
          cbi(flag, TUCH_FLAG);
          sbi(flag, LINE_FLAG);
          MUSIC=1;
          cnt=0;
          time=0;
          putchar('T');
            }
       }
       }

interrupt [TIM0_COMPA] void comp_a_25us()
{
 RST_T0;
 sensor_drv();
 time++;

    if( flag & (1<<LINE_FLAG) )    line();

    if( flag & (1<<ONE_LED_FLAG) ) one_led();

    if( flag & (1<<FULL_FLAG) )    full();

    if( flag & (1<<LAST_FLAG) )    last();

    if( flag & (1<<MIG_FLAG) )      mig();

  }

interrupt [TIM1_COMPA] void comp_a_200ms()
{
 RST_T1;
 cnt++;
 }
