using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using SimpleJSON;
using YanhuaMMO;
public class DynamicHeightList : MonoBehaviour , IBeginDragHandler, IDragHandler, IEndDragHandler
{
 
    public Vector2 minCellSize;
 
    public int maxRowCount = 5;
 
    public int columeCount = 1;//列数
 
    public Vector2 spaceSize;
 
    private List<DynamicInfinityItem> itemList;
 
    public GameObject renderGo;
 
    protected IList mDataProviders;
 
    private Vector2 lastDownMousePos;
 
    private bool isMouseDown = false;
 
    public int elasticDist = 25;
 
    private int validCount = 0;
 
    private float viewheight;
 
    private float zuni = 0.95f;
 
    private Coroutine guanxingCo;
 
    private List<DynamicInfinityItem> allItemRenders;
 
    private Vector3 startDownPos;
 
    // Use this for initialization
    void Start () {
       
        viewheight = gameObject.GetComponent<RectTransform>().sizeDelta.y;
 
        itemList = new List<DynamicInfinityItem>();
        //validCount = Mathf.Min(mDataProviders.Count, maxRowCount * columeCount);
 
        initItem();
       // updateValidItem();
 
        //AddTriggersListener(gameObject, EventTriggerType.PointerDown, startDrag);
        //AddTriggersListener(gameObject, EventTriggerType.PointerUp, stopDrag);
 
    }
 
    public void OnBeginDrag(PointerEventData eventData)
    {
        startDrag(eventData);
    }
 
    public void OnEndDrag(PointerEventData eventData)
    {
        stopDrag(eventData);
    }
 
    public void OnDrag(PointerEventData eventData)
    {
 
    }
 
    public void setDataByJsonArray(string dataarr)
    {
        JSONArray dataList = JSON.Parse(dataarr).AsArray;
        List<JSONNode> dataNode = new List<JSONNode>();
        for (int i = 0; i < dataList.Count; i++)
            dataNode.Add(dataList[i]);
        setDataProvider(dataNode);
    }
    public void setDataProvider(IList dataprovider)
    {
        StopAllCoroutines();
        mDataProviders = dataprovider;
        validCount = Mathf.Min(mDataProviders.Count, maxRowCount * columeCount);
 
        updateValidItem();
        if (itemList.Count == 0)
            return;
        itemList[0].transform.localPosition = new Vector3(0, 0, 0);
        updateItemPos();
    }
    private void startDrag(BaseEventData data)
    {
        isMouseDown = true;
        if (itemList.Count == 0)
            return;
 
        lastDownMousePos = Input.mousePosition;
        startDownPos = Input.mousePosition;
        if (guanxingCo != null)
            StopCoroutine(guanxingCo);
        StopAllCoroutines();
        StartCoroutine(moveContent());
    }
 
    private void stopDrag(BaseEventData data)
    {
        isMouseDown = false;
 
        if (itemList.Count ==  0)
            return;
        if (itemList[0].itemIndex == 0 && itemList[0].transform.localPosition.y < 0)
        {
            StartCoroutine(tweenToTop());
            return;
        }
 
        if (itemList[validCount - 1].itemIndex == mDataProviders.Count - 1 &&
               (itemList[validCount - 1].transform.localPosition.y > itemList[validCount - 1].itemHeight - viewheight))
        {
            StartCoroutine(tweenToBottom());
 
            return;
        }
        guanxingCo = StartCoroutine(guanxingMove(Input.mousePosition.y - lastDownMousePos.y));
       
    }
 
     IEnumerator guanxingMove(float initdist)
    {
        float origindist = initdist;
 
        while(Mathf.Abs(origindist) > 0.01f)
        {
            // Debug.Log("guangxin:" + origindist);
            if (itemList[0].itemIndex == 0 && itemList[0].transform.localPosition.y < 0)
            {
                StartCoroutine(tweenToTop());
 
                break;
            }
            if (itemList[validCount - 1].itemIndex == mDataProviders.Count - 1 &&
                (itemList[validCount - 1].transform.localPosition.y > itemList[validCount - 1].itemHeight - viewheight))
            {
                StartCoroutine(tweenToBottom());
 
                break;
            }
            moveItemPos(origindist);
            origindist *= 0.96f;
 
            yield return 0;
        }
 
    }
 
    IEnumerator moveContent()
    {
        while(isMouseDown && itemList.Count > 0)
        {
            float deltaposy = Input.mousePosition.y - lastDownMousePos.y;
            float zushi = 1;
            if(deltaposy < 0 && itemList[0].itemIndex == 0)
            {
               // if (itemList[0].transform.localPosition.y < -elasticDist)
               //     deltaposy = 0;
                if (itemList[0].transform.localPosition.y < 0)
                    zushi = Mathf.Pow(zuni, elasticDist - itemList[0].transform.localPosition.y);
            }
            else if (deltaposy > 0 && itemList[validCount - 1].itemIndex == mDataProviders.Count - 1)
            {
                float pos = viewheight - itemList[validCount - 1].itemHeight;
 
                //if (itemList[validCount - 1].transform.localPosition.y > -pos + elasticDist)
                //   deltaposy = 0;
                if (itemList[0].itemIndex == 0 && itemList[0].transform.localPosition.y < 0)
                    zushi = 1;
                else if(itemList[validCount - 1].transform.localPosition.y > -pos)
                    // zushi = Mathf.Pow(zuni, itemList[validCount - 1].transform.localPosition.y + pos);     
                    zushi = Mathf.Pow(zuni, Mathf.Abs(Input.mousePosition.y - startDownPos.y));
 
            }
 
           // Debug.Log("delat:" + deltaposy);
            if (Mathf.Abs(zushi) < 0.01f)
                zushi = 0;
            deltaposy *= zushi;
            if(deltaposy != 0)
                moveItemPos(deltaposy);
 
             lastDownMousePos = Input.mousePosition;
            yield return 0;
 
        }
 
    }
 
    IEnumerator tweenToTop()
    {
        Debug.Log("tweenToTop :");
 
        while (itemList[0].transform.localPosition.y != 0)
        {
            float dist = Mathf.Min(3f, -itemList[0].transform.localPosition.y);
            for (int i = 0; i < itemList.Count; i++)
            {
                Vector3 lpos = itemList[i].transform.localPosition;
                itemList[i].transform.localPosition = new Vector3(lpos.x, lpos.y + dist, 0);
            }
 
            yield return 0;
        }
 
    }
 
    IEnumerator tweenToBottom()
    {
        Debug.Log("tweenToBottom:");
 
        float bottomy = itemList[validCount - 1].itemHeight - viewheight;
 
        while (itemList[validCount - 1].transform.localPosition.y > bottomy && itemList[0].transform.localPosition.y > 0)
        {
           // float dist = 0;
            //if (validCount >= maxRowCount * columeCount)
                float dist = Mathf.Max(-3f,  bottomy - itemList[validCount - 1].transform.localPosition.y);
          
 
            for (int i = 0; i < itemList.Count; i++)
            {
                Vector3 lpos = itemList[i].transform.localPosition;
                itemList[i].transform.localPosition = new Vector3(lpos.x, lpos.y + dist, 0);
            }
 
            yield return 0;
        }
 
    }
 
    private void moveItemPos(float dist)
    {
         for (int i = 0; i < itemList.Count; i++)
        {
        
            Vector3 lpos = itemList[i].transform.localPosition;
 
            itemList[i].transform.localPosition = new Vector3(lpos.x, lpos.y + dist, 0);
        }
 
   
 
        for (int i = 0; i < itemList.Count; i++)
        {
            Vector3 lpos = itemList[i].transform.localPosition;
            float heightitem = itemList[i].itemHeight;
            if (dist >= 0 && lpos.y > heightitem && itemList[itemList.Count - 1].itemIndex < mDataProviders.Count - 1)
            {
 
                DynamicInfinityItem rd = itemList[i];
                rd.itemIndex = itemList[itemList.Count - 1].itemIndex + 1;
 
                int row = Mathf.FloorToInt(rd.itemIndex/columeCount);
                int row1 = Mathf.FloorToInt((rd.itemIndex - 1)/ columeCount);
 
                if(row > row1)
                    lpos.y = itemList[itemList.Count - 1].transform.localPosition.y - itemList[itemList.Count - 1].itemHeight - spaceSize.y;
                else
                    lpos.y = itemList[itemList.Count - 1].transform.localPosition.y ;
 
                itemList[i].transform.localPosition = lpos;
 
                rd.SetData(mDataProviders[rd.itemIndex]);
                //Debug.Log("data index:" + rd.itemIndex);
                itemList.RemoveAt(i);
                itemList.Add(rd);
                i--;
 
            }
            else if (dist < 0 && lpos.y < -viewheight && itemList[0].itemIndex > 0)
            {
 
                DynamicInfinityItem rd = itemList[i];
                rd.itemIndex = itemList[0].itemIndex - 1;
 
                int row = Mathf.FloorToInt(rd.itemIndex / columeCount);
                int row1 = Mathf.FloorToInt((rd.itemIndex + 1) / columeCount);
 
                if (row < row1)
                    lpos.y = itemList[0].transform.localPosition.y + itemList[i].itemHeight + spaceSize.y;
                else
                    lpos.y = itemList[0].transform.localPosition.y;
 
                int column = rd.itemIndex % columeCount;
                lpos.x = (minCellSize.x + spaceSize.x) * column;
 
                itemList[i].transform.localPosition = lpos;
 
                rd.SetData(mDataProviders[rd.itemIndex]);
                itemList.RemoveAt(i);
                itemList.Insert(0, rd);
            }
        }
        //updateItemPos();
    }
    private void AddTriggersListener(GameObject obj, EventTriggerType eventID, UnityAction<BaseEventData> action)
    {
        EventTrigger trigger = obj.GetComponent<EventTrigger>();
        if (trigger == null)
        {
            trigger = obj.AddComponent<EventTrigger>();
        }
 
        if (trigger.triggers.Count == 0)
        {
            trigger.triggers = new List<EventTrigger.Entry>();
        }
 
        UnityAction<BaseEventData> callback = new UnityAction<BaseEventData>(action);
        EventTrigger.Entry entry = new EventTrigger.Entry();
        entry.eventID = eventID;
        entry.callback.AddListener(callback);
        trigger.triggers.Add(entry);
 
       
       }
    private void initItem()
    {
        int total = maxRowCount * columeCount;
        allItemRenders = new List<DynamicInfinityItem>();
        for (int i=0;i < total;i++)
        {
            GameObject itemgo = Instantiate(renderGo);
            ItemRender render= itemgo.GetComponent<ItemRender>();
            itemgo.transform.SetParent(transform);
            itemgo.SetActive(false);
            int row = Mathf.FloorToInt(i / columeCount);
            int column = i % columeCount;
 
            itemgo.transform.localPosition = new Vector3((minCellSize.x + spaceSize.x) * column, -(minCellSize.y + spaceSize.y) * row, 0);
            itemgo.transform.localScale = Vector3.one;
            itemgo.transform.localEulerAngles = Vector3.zero;
 
            allItemRenders.Add(render);         
 
        }
 
    }
 
    private void updateValidItem()
    {
        itemList = new List<DynamicInfinityItem>();
        for (int i = 0; i < allItemRenders.Count; i++)
        {
            GameObject itemgo = allItemRenders[i].gameObject;
 
           
 
            allItemRenders[i].itemIndex = i;
 
            if (i < mDataProviders.Count)
            {
                itemgo.gameObject.SetActive(true);
                allItemRenders[i].SetData(mDataProviders[i]);
                itemList.Add(allItemRenders[i]);
 
            }
            else
                itemgo.gameObject.SetActive(false);
        }
 
    }
 
    public void updateItemPos()
    {
        if (columeCount > 1)
        {
            for (int i = 0; i < itemList.Count; i++)
            {
                GameObject itemgo = itemList[i].gameObject;
                int row = Mathf.FloorToInt(i / columeCount);
                int column = i % columeCount;
 
                itemgo.transform.localPosition = new Vector3((minCellSize.x + spaceSize.x) * column, -(minCellSize.y + spaceSize.y) * row, 0);
                itemgo.transform.localScale = Vector3.one;
                itemgo.transform.localEulerAngles = Vector3.zero;
            }
            return;
 
        }
 
        for (int i=1;i < itemList.Count;i++)
        {
            float tempposy = itemList[i - 1].transform.localPosition.y - itemList[i - 1].itemHeight - spaceSize.y;
            itemList[i].transform.localPosition = new Vector3(itemList[i].transform.localPosition.x, tempposy, 0);
        }
       // moveItemPos(0);
    }
 
    public void moveToIndex(int dataIndex,bool imediate)
    {
        if (mDataProviders.Count <= dataIndex)
            return;
 
       
        DynamicInfinityItem fisrtitem = null;//= itemList[0].itemIndex;
        for (int i = 0; i < itemList.Count; i++)
        {
            if (itemList[i].transform.localPosition.y <= 0)
            {
                fisrtitem = itemList[i];
                break;
            }
        }
 
        if (fisrtitem != null && fisrtitem.itemIndex >= dataIndex)
        {
           // if(itemList[0].transform.localPosition.y >= 0)
            {
                StartCoroutine(scrollToIndex(dataIndex, -1, imediate));
            }
        }
        else
            StartCoroutine(scrollToIndex(dataIndex, 1, imediate));
    }
 
    IEnumerator scrollToIndex(int moveIndex, float direct,bool imediate)
    {
        if (direct < 0)
        {
            while (true)
            {
                moveItemPos(-10);
                for(int i=0;i < itemList.Count;i++)
                {
                    if (itemList[i].itemIndex == moveIndex && itemList[i].transform.localPosition.y <= 0)
                    {
                        moveItemPos(-itemList[i].transform.localPosition.y);
                        yield break;
                    }
                }
                if(!imediate)
                yield return new WaitForSeconds(0.001f);
            }
 
        }
        if (direct > 0)
        {
            while (itemList[0].itemIndex != moveIndex && (itemList[validCount - 1].itemIndex < mDataProviders.Count - 1 || itemList[validCount - 1].transform.localPosition.y < itemList[validCount - 1].itemHeight - viewheight))
            {
                moveItemPos(10);
                if (!imediate)
                    yield return new WaitForSeconds(0.001f);
            }
 
            for (int i = 0; i < itemList.Count; i++)
            {
                if (itemList[i].transform.localPosition.y - itemList[i].itemHeight <= 0)
                {
                    moveItemPos(-itemList[i].transform.localPosition.y);
                    yield break;
                }
            }
 
        }
    }
   
 }